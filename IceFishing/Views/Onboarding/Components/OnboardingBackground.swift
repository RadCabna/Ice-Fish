import SwiftUI

struct OnboardingBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color("bgColor_1"), Color("bgColor_2")],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

extension View {
    func onboardingBackground() -> some View {
        background {
            OnboardingBackground()
        }
    }
}

#Preview {
    OnboardingBackground()
}
