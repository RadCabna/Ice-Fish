import SwiftUI

@MainActor
final class MainTabViewModel: ObservableObject {
    @Published var selectedTab: MainTab = .session
    @Published var sessionPath = NavigationPath()
    @Published var journalPath = NavigationPath()
    @Published var analyticsPath = NavigationPath()
    @Published var rulesPath = NavigationPath()
    @Published var settingsPath = NavigationPath()
}
