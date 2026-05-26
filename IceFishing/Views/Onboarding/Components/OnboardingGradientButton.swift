import SwiftUI

struct OnboardingGradientButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [Color("buttonColor_1"), Color("buttonColor_2")],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var disabledBackground: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.18),
                Color.white.opacity(0.12)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    private var cornerRadius: CGFloat {
        screenHeight * 0.017
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: screenHeight * 0.02, weight: .semibold))
                .foregroundStyle(.white.opacity(isEnabled ? 1 : 0.55))
                .frame(maxWidth: .infinity)
                .frame(minHeight: screenHeight * 0.062)
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            isEnabled
                                ? AnyShapeStyle(gradient)
                                : AnyShapeStyle(disabledBackground)
                        )
                }
        }
        .shadow(
            color: Color("buttonColor_2").opacity(isEnabled ? 0.4 : 0),
            radius: screenHeight * 0.017,
            y: screenHeight * 0.007
        )
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true) {
        OnboardingGradientButton(title: "Continue") {}
    }
}
