import SwiftUI

struct PreviewHost<Content: View>: View {
    var useOnboardingBackground: Bool = false
    var appliesPadding: Bool = true
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            if useOnboardingBackground {
                OnboardingBackground()
            }

            Group {
                content()
            }
            .padding(appliesPadding ? ScreenSize.width * 0.062 : 0)
        }
    }
}
