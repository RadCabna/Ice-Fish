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

    var sonarBlips: [SonarBlip] {
        guard !sessions.isEmpty else { return [] }

        let recent = sessions
            .sorted { $0.summary.endedAt > $1.summary.endedAt }
            .prefix(10)

        let maxCatches = max(1, recent.map(\.summary.totalCatchCount).max() ?? 1)

        return recent.map { session in
            let catchCount = session.summary.totalCatchCount
            return SonarBlip(
                id: session.id,
                catchCount: catchCount,
                distanceFromCenter: Self.distanceFromCenter(for: catchCount, maxCatches: maxCatches),
                angle: Self.stableAngle(seed: session.id)
            )
        }
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
        for byte in seed.uuid.1...seed.uuid.15 {
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
