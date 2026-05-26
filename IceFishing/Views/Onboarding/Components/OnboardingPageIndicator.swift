import SwiftUI

struct OnboardingPageIndicator: View {
    let currentPage: Int
    let totalPages: Int

    private let activeColor = Color(red: 0.45, green: 0.78, blue: 1.0)
    private let inactiveColor = Color.white.opacity(0.2)

    var body: some View {
        HStack(spacing: screenWidth * 0.015) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(
                        width: index == currentPage ? screenWidth * 0.09 : screenWidth * 0.09,
                        height: screenHeight * 0.005
                    )
            }
        }
        .animation(.easeInOut(duration: 0.25), value: currentPage)
        .accessibilityLabel("Page \(currentPage + 1) of \(totalPages)")
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true) {
        OnboardingPageIndicator(currentPage: 1, totalPages: 4)
    }
}
