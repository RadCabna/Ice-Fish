import Foundation

enum CatchEventType: String, CaseIterable, Identifiable {
    case smallFish
    case bigFish
    case bonus
    case deadIce

    var id: String { rawValue }

    var title: String {
        switch self {
        case .smallFish:
            return "Small Catch"
        case .bigFish:
            return "Big Catch"
        case .bonus:
            return "Bonus"
        case .deadIce:
            return "Dead Ice"
        }
    }

    var placeholderDelta: Double {
        switch self {
        case .smallFish:
            return 5
        case .bigFish:
            return 20
        case .bonus:
            return 30
        case .deadIce:
            return -15
        }
    }

    var deltaLabel: String {
        let value = abs(placeholderDelta)
        let sign = placeholderDelta >= 0 ? "+" : "-"
        return "\(sign)$\(Int(value))"
    }
}
