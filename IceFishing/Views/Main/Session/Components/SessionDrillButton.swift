import SwiftUI

struct SessionDrillButton: View {
    let title: String
    var isEnabled: Bool
    let action: () -> Void

    private var activeGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.2, green: 0.75, blue: 0.95),
                Color(red: 0.1, green: 0.55, blue: 0.85)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: screenWidth * 0.02) {
                Image(systemName: "snowflake")
                    .font(.system(size: screenHeight * 0.018, weight: .semibold))

                Text(title)
                    .font(.system(size: screenHeight * 0.02, weight: .semibold))
            }
            .foregroundStyle(.white.opacity(isEnabled ? 1 : 0.5))
            .frame(maxWidth: .infinity)
            .frame(minHeight: screenHeight * 0.062)
            .background {
                RoundedRectangle(cornerRadius: screenHeight * 0.017, style: .continuous)
                    .fill(
                        isEnabled
                            ? AnyShapeStyle(activeGradient)
                            : AnyShapeStyle(SessionStyle.disabledButtonFill)
                    )
            }
            .overlay {
                if !isEnabled {
                    RoundedRectangle(cornerRadius: screenHeight * 0.017, style: .continuous)
                        .stroke(SessionStyle.cardStroke, lineWidth: SessionStyle.cardBorderWidth)
                }
            }
        }
        .shadow(
            color: Color(red: 0.2, green: 0.75, blue: 0.95).opacity(isEnabled ? 0.35 : 0),
            radius: screenHeight * 0.014,
            y: screenHeight * 0.006
        )
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack {
        SessionDrillButton(title: "Drill The Hole", isEnabled: false) {}
        SessionDrillButton(title: "Drill The Hole", isEnabled: true) {}
    }
    .padding()
    .mainBackground()
}
