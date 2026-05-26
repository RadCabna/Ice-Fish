import SwiftUI

struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainView()
            } else {
                OnboardingView {
                    hasCompletedOnboarding = true
                }
            }
        }
        .dismissKeyboardOnTapOutside()
    }
}

#Preview {
    RootView()
}
