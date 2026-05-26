import Foundation

enum MainTab: Int, CaseIterable, Identifiable, Hashable {
    case session = 0
    case journal = 1
    case analytics = 2
    case rules = 3
    case settings = 4

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .session:
            return "Session"
        case .journal:
            return "Journal"
        case .analytics:
            return "Analytics"
        case .rules:
            return "Rules"
        case .settings:
            return "Settings"
        }
    }

    var assetIndex: Int {
        rawValue + 1
    }

    func iconAssetName(isSelected: Bool) -> String {
        let prefix = isSelected ? "tabOn" : "tabOff"
        return "\(prefix)_\(assetIndex)"
    }
}
