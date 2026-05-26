import SwiftUI
import UIKit

struct MainView: View {
    @StateObject private var tabViewModel = MainTabViewModel()
    @StateObject private var sessionFlowViewModel = SessionFlowViewModel()
    @StateObject private var journalViewModel = JournalViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var keyboardVisibility = KeyboardVisibility()
    @Environment(\.scenePhase) private var scenePhase

    private var tabBarReservedHeight: CGFloat {
        screenHeight * 0.1
    }

    private var isSessionTabBarAllowed: Bool {
        guard tabViewModel.selectedTab == .session else { return true }
        return sessionFlowViewModel.path.isEmpty
    }

    private var isTabBarVisible: Bool {
        isSessionTabBarAllowed && !keyboardVisibility.isVisible
    }

    private var tabBarBottomPadding: CGFloat {
        isTabBarVisible ? tabBarReservedHeight : 0
    }

    var body: some View {
        ZStack {
            AppBackground()

            TabView(selection: $tabViewModel.selectedTab) {
                MainTabRoot {
                    tabStack(path: $tabViewModel.journalPath) {
                        JournalView(viewModel: journalViewModel)
                    }
                }
                .tag(MainTab.journal)

                MainTabRoot {
                    SessionFlowContainer(
                        flowViewModel: sessionFlowViewModel,
                        journalViewModel: journalViewModel,
                        tabViewModel: tabViewModel
                    )
                }
                .tag(MainTab.session)

                MainTabRoot {
                    tabStack(path: $tabViewModel.analyticsPath) {
                        AnalyticsView(journalViewModel: journalViewModel)
                    }
                }
                .tag(MainTab.analytics)

                MainTabRoot {
                    tabStack(path: $tabViewModel.rulesPath) {
                        RulesView()
                    }
                }
                .tag(MainTab.rules)

                MainTabRoot {
                    tabStack(path: $tabViewModel.settingsPath) {
                        SettingsView(
                            journalViewModel: journalViewModel,
                            settingsViewModel: settingsViewModel
                        )
                    }
                }
                .tag(MainTab.settings)
            }
            .toolbar(.hidden, for: .tabBar)
            .padding(.bottom, tabBarBottomPadding)
            .background(SystemTabViewBackgroundClear())
            .animation(.spring(response: 0.38, dampingFraction: 0.82), value: isTabBarVisible)

        }
        .overlay(alignment: .bottom) {
            MainTabBar(selectedTab: $tabViewModel.selectedTab)
                .padding(.horizontal, screenWidth * 0.04)
                .offset(y: isTabBarVisible ? 0 : tabBarReservedHeight)
                .opacity(isTabBarVisible ? 1 : 0)
                .allowsHitTesting(isTabBarVisible)
                .animation(.spring(response: 0.38, dampingFraction: 0.82), value: isTabBarVisible)
        }
        .background {
            AppBackground()
        }
        .dismissKeyboardOnTapOutside()
        .environmentObject(settingsViewModel)
        .preferredColorScheme(settingsViewModel.darkModeEnabled ? .dark : .light)
        .onAppear {
            configureNavigationAndTabBarAppearances()
            clearSystemContainerBackgrounds()
            sessionFlowViewModel.updateDefaultDuration(settingsViewModel.defaultSessionMinutes)
            KeyboardDismissController.shared.install()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                KeyboardDismissController.shared.install()
            }
        }
        .onChange(of: tabViewModel.selectedTab) { _, tab in
            clearSystemContainerBackgrounds()
            if tab == .session {
                sessionFlowViewModel.resetSetupFormOnTabEntry()
            }
        }
        .onChange(of: settingsViewModel.defaultSessionMinutes) { _, minutes in
            sessionFlowViewModel.updateDefaultDuration(minutes)
        }
    }

    private func tabStack<Content: View>(
        path: Binding<NavigationPath>,
        @ViewBuilder content: () -> Content
    ) -> some View {
        NavigationStack(path: path) {
            content()
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
    }

    private func configureNavigationAndTabBarAppearances() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor = .clear
        tabBarAppearance.shadowColor = .clear

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().isHidden = true

        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithTransparentBackground()
        navigationAppearance.backgroundColor = .clear
        navigationAppearance.shadowColor = .clear

        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
    }

    private func clearSystemContainerBackgrounds() {
        DispatchQueue.main.async {
            guard let root = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap(\.windows)
                .first(where: \.isKeyWindow)?
                .rootViewController
            else { return }

            if let tabBarController = findTabBarController(in: root) {
                tabBarController.view.backgroundColor = .clear
                tabBarController.view.isOpaque = false
            }

            for navigationController in findNavigationControllers(in: root) {
                navigationController.view.backgroundColor = .clear
                navigationController.view.isOpaque = false
            }
        }
    }

    private func findTabBarController(in viewController: UIViewController) -> UITabBarController? {
        if let tabBarController = viewController as? UITabBarController {
            return tabBarController
        }
        for child in viewController.children {
            if let found = findTabBarController(in: child) {
                return found
            }
        }
        if let presented = viewController.presentedViewController {
            return findTabBarController(in: presented)
        }
        return nil
    }

    private func findNavigationControllers(in viewController: UIViewController) -> [UINavigationController] {
        var result: [UINavigationController] = []
        if let navigationController = viewController as? UINavigationController {
            result.append(navigationController)
        }
        for child in viewController.children {
            result.append(contentsOf: findNavigationControllers(in: child))
        }
        if let presented = viewController.presentedViewController {
            result.append(contentsOf: findNavigationControllers(in: presented))
        }
        return result
    }
}

private struct SystemTabViewBackgroundClear: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            guard let tabBarController = uiViewController.tabBarController else { return }
            tabBarController.view.backgroundColor = .clear
            tabBarController.view.isOpaque = false
        }
    }
}

#Preview {
    MainView()
}
