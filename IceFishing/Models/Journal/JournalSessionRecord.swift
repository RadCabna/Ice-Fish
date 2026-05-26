import Foundation

struct JournalSessionRecord: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let summary: SessionSummary
    let stopLoss: Double
    let takeProfit: Double
    let note: String?

    init(
        id: UUID = UUID(),
        summary: SessionSummary,
        config: SessionConfig,
        note: String? = nil
    ) {
        self.id = id
        self.summary = summary
        self.stopLoss = config.stopLoss
        self.takeProfit = config.takeProfit
        self.note = note
    }

    var isWin: Bool {
        summary.balance > 0
    }

    var isLoss: Bool {
        summary.balance < 0
    }

    var isFrozen: Bool {
        summary.frostPeakPercent >= 100
    }

    var formattedDate: String {
        summary.endedAt.formatted(
            Date.FormatStyle(date: .abbreviated, time: .shortened)
        )
    }

    var formattedDuration: String {
        let minutes = summary.durationSeconds / 60
        if minutes >= 60 {
            let hours = minutes / 60
            let remainder = minutes % 60
            if remainder == 0 {
                return "\(hours)h"
            }
            return "\(hours)h \(remainder)m"
        }
        if minutes > 0 {
            return "\(minutes)m"
        }
        return "\(summary.durationSeconds) sec"
    }

    func matches(filter: JournalFilter) -> Bool {
        switch filter {
        case .all:
            return true
        case .wins:
            return isWin
        case .losses:
            return isLoss
        case .frozen:
            return isFrozen
        }
    }
}
