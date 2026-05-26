import Foundation

enum JournalFilter: String, CaseIterable, Identifiable {
    case all
    case wins
    case losses
    case frozen

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:
            return "All"
        case .wins:
            return "Wins"
        case .losses:
            return "Losses"
        case .frozen:
            return "Frozen Sessions"
        }
    }
}
