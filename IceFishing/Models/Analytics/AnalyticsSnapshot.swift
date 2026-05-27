import Foundation

struct BankrollPoint: Identifiable, Equatable {
    let id: Int
    let label: String
    let balance: Double
}

struct SonarBlip: Identifiable, Equatable {
    let id: UUID
    let catchCount: Int
    /// 0 = center (many catches), 1 = outer edge (few catches)
    let distanceFromCenter: CGFloat
    let angle: Double
}

struct CatchDistributionValues: Equatable {
    let smallCatches: Double
    let bigMulti: Double
    let bonuses: Double
    let deadIce: Double

    static let zero = CatchDistributionValues(
        smallCatches: 0,
        bigMulti: 0,
        bonuses: 0,
        deadIce: 0
    )
}

struct FrostStatItem: Identifiable {
    let id: String
    let iconName: String
    let iconColorName: AnalyticsIconColor
    let title: String
    let value: String
}

enum AnalyticsIconColor {
    case orange
    case cyan
    case red
    case purple
}

struct AnalyticsSnapshot {
    let sessions: [JournalSessionRecord]

    var bankrollPoints: [BankrollPoint] {
        let calendar = Calendar.current
        let ordered = sessions.sorted { $0.summary.endedAt < $1.summary.endedAt }

        var dailyTotals: [(day: Date, total: Double)] = []
        for record in ordered {
            let day = calendar.startOfDay(for: record.summary.endedAt)
            if let lastIndex = dailyTotals.indices.last,
               calendar.isDate(dailyTotals[lastIndex].day, inSameDayAs: day) {
                dailyTotals[lastIndex].total += record.summary.balance
            } else {
                dailyTotals.append((day: day, total: record.summary.balance))
            }
        }

        var cumulative = 0.0
        return dailyTotals.enumerated().map { index, entry in
            cumulative += entry.total
            return BankrollPoint(
                id: index,
                label: "Day \(index + 1)",
                balance: cumulative
            )
        }
    }

    var bankrollYMax: Double {
        let maxBalance = bankrollPoints.map(\.balance).max() ?? 0
        return max(100, ceil(maxBalance / 25) * 25)
    }

    var catchDistribution: CatchDistributionValues {
        guard !sessions.isEmpty else { return .zero }

        let small = Double(sessions.reduce(0) { $0 + $1.summary.smallCatchCount })
        let big = Double(sessions.reduce(0) { $0 + $1.summary.bigCatchCount })
        let bonus = Double(sessions.reduce(0) { $0 + $1.summary.bonusCount })
        let deadIce = Double(sessions.filter { $0.summary.balance < 0 }.count)

        let maxValue = [1.0, small, big, bonus, deadIce].max() ?? 1
        let scale = 3.0 / maxValue

        return CatchDistributionValues(
            smallCatches: small * scale,
            bigMulti: big * scale,
            bonuses: bonus * scale,
            deadIce: deadIce * scale
        )
    }

    var averageFrostPercent: Int {
        guard !sessions.isEmpty else { return 0 }
        let total = sessions.reduce(0) { $0 + $1.summary.frostPeakPercent }
        return Int((Double(total) / Double(sessions.count)).rounded())
    }

    var longestSessionMinutes: Int {
        guard let maxSeconds = sessions.map(\.summary.durationSeconds).max() else { return 0 }
        if maxSeconds == 0 { return 0 }
        return max(1, Int(ceil(Double(maxSeconds) / 60)))
    }

    var dangerousSessionsCount: Int {
        sessions.filter { $0.summary.frostPeakPercent >= 80 }.count
    }

    var totalSessionsCount: Int {
        sessions.count
    }

    var insightText: String {
        guard !sessions.isEmpty else {
            return "Start fishing to build performance analytics."
        }

        let bonusSessions = sessions.filter { $0.summary.bonusCount > 0 }
        let nonBonusSessions = sessions.filter { $0.summary.bonusCount == 0 }

        if !bonusSessions.isEmpty, !nonBonusSessions.isEmpty {
            let bonusFrost = averageFrost(for: bonusSessions)
            let otherFrost = averageFrost(for: nonBonusSessions)
            if bonusFrost < otherFrost {
                return "Bonus sessions reduce frost accumulation."
            }
        }

        if dangerousSessionsCount > 0 {
            return "High frost sessions correlate with shorter bankroll runs."
        }

        return "Keep sessions under 30 minutes for sharper decisions."
    }

    private static let maxSonarBlips = 7

    var sonarBlips: [SonarBlip] {
        guard !sessions.isEmpty else { return [] }

        let recent = sessions.sorted { $0.summary.endedAt > $1.summary.endedAt }
        let maxCatches = max(1, recent.map(\.summary.totalCatchCount).max() ?? 1)

        var blips: [SonarBlip] = []
        var remaining = Self.maxSonarBlips

        for session in recent {
            guard remaining > 0 else { break }

            let summary = session.summary
            let desiredCount = Self.desiredBlipCount(for: summary)
            guard desiredCount > 0 else { continue }

            let count = min(desiredCount, remaining)
            let distance = Self.distanceFromCenter(
                for: summary.totalCatchCount,
                maxCatches: maxCatches
            )
            let angles = Self.spreadAngles(seed: session.id, count: count)

            for index in 0..<count {
                blips.append(
                    SonarBlip(
                        id: Self.blipID(sessionID: session.id, index: index),
                        catchCount: summary.totalCatchCount,
                        distanceFromCenter: distance,
                        angle: angles[index]
                    )
                )
            }

            remaining -= count
        }

        return blips
    }

    /// More small catches → more blips on the same radius (spread by angle).
    static func desiredBlipCount(for summary: SessionSummary) -> Int {
        guard summary.totalCatchCount > 0 else { return 0 }

        if summary.smallCatchCount <= 0 {
            return 1
        }

        // 1 blip for first small catch, then +1 per pair of additional small catches (max 4 per session).
        let fromSmall = 1 + (summary.smallCatchCount - 1) / 2
        return min(4, fromSmall)
    }

    static func spreadAngles(seed: UUID, count: Int) -> [Double] {
        let base = stableAngle(seed: seed)
        guard count > 1 else { return [base] }

        let spread = min(.pi / 2.5, Double(count - 1) * 0.2)
        let start = base - spread / 2

        return (0..<count).map { index in
            let progress = Double(index) / Double(count - 1)
            return start + progress * spread
        }
    }

    static func blipID(sessionID: UUID, index: Int) -> UUID {
        var bytes = sessionID.uuid
        bytes.14 = UInt8((Int(bytes.14) + index * 3) % 256)
        bytes.15 = UInt8((Int(bytes.15) + index * 11) % 256)
        return UUID(uuid: bytes)
    }

    static func distanceFromCenter(for catchCount: Int, maxCatches: Int) -> CGFloat {
        let inner: CGFloat = 0.14
        let outer: CGFloat = 0.88

        guard maxCatches > 0 else { return outer }
        guard catchCount > 0 else { return outer }

        let ratio = CGFloat(catchCount) / CGFloat(maxCatches)
        return outer - ratio * (outer - inner)
    }

    static func stableAngle(seed: UUID) -> Double {
        var hash = Int(seed.uuid.0)
        // IMPORTANT:
        // `seed.uuid.1...seed.uuid.15` would create a range from *byte values*
        // (0...255), and lowerBound can be > upperBound -> fatal error.
        // We iterate over a fixed list of bytes instead.
        let bytes: [UInt8] = [
            seed.uuid.1, seed.uuid.2, seed.uuid.3, seed.uuid.4,
            seed.uuid.5, seed.uuid.6, seed.uuid.7, seed.uuid.8,
            seed.uuid.9, seed.uuid.10, seed.uuid.11, seed.uuid.12,
            seed.uuid.13, seed.uuid.14, seed.uuid.15
        ]
        for byte in bytes {
            hash = hash &* 31 &+ Int(byte)
        }
        let unit = Double(abs(hash % 10_000)) / 10_000.0
        return unit * 2 * .pi - .pi / 2
    }

    private func averageFrost(for records: [JournalSessionRecord]) -> Int {
        guard !records.isEmpty else { return 0 }
        let total = records.reduce(0) { $0 + $1.summary.frostPeakPercent }
        return Int((Double(total) / Double(records.count)).rounded())
    }

    static func make(from sessions: [JournalSessionRecord]) -> AnalyticsSnapshot {
        AnalyticsSnapshot(sessions: sessions)
    }
}
