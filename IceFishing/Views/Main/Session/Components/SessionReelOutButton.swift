import SwiftUI

struct SessionReelOutButton: View {
    let action: () -> Void

    private var gradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 1.0, green: 0.48, blue: 0.12),
                Color(red: 1.0, green: 0.28, blue: 0.18)
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
            Text("Reel Out")
                .font(.system(size: screenHeight * 0.02, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: screenHeight * 0.062)
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(gradient)
                }
        }
        .buttonStyle(.plain)
        .shadow(
            color: Color(red: 1.0, green: 0.35, blue: 0.15).opacity(0.35),
            radius: screenHeight * 0.014,
            y: screenHeight * 0.006
        )
        .accessibilityLabel("Reel out")
    }
}

#Preview {
    SessionReelOutButton(action: {})
        .padding()
        .mainBackground()
}
