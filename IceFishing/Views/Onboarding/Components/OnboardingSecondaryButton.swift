import SwiftUI

struct OnboardingSecondaryButton: View {
    let title: String
    let action: () -> Void

    private var cornerRadius: CGFloat {
        screenHeight * 0.017
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: screenHeight * 0.02, weight: .medium))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: screenHeight * 0.062)
                .roundedPanel(
                    cornerRadius: cornerRadius,
                    fill: SurfaceStyle.subtleFill,
                    stroke: Color.white.opacity(0.18),
                    lineWidth: screenHeight * 0.0012
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true) {
        OnboardingSecondaryButton(title: "Learn More") {}
    }
}
