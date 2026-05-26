import SwiftUI

struct JournalEmptyStateView: View {
    var body: some View {
        VStack(spacing: screenHeight * 0.02) {
            glowingOrb
                .frame(height: screenHeight * 0.22)

            Text("No sessions yet.")
                .font(.system(size: screenHeight * 0.02, weight: .semibold))
                .foregroundStyle(.white)

            Text("Start fishing to build your history.")
                .font(.system(size: screenHeight * 0.016))
                .foregroundStyle(Color.white.opacity(0.55))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, screenHeight * 0.08)
    }

    private var glowingOrb: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.white.opacity(0.95),
                        Color.white.opacity(0.4),
                        Color(red: 0.45, green: 0.78, blue: 1.0).opacity(0.28),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: screenWidth * 0.22
                )
            )
            .frame(width: screenWidth * 0.36, height: screenWidth * 0.36)
            .blur(radius: screenHeight * 0.012)
            .shadow(color: Color(red: 0.35, green: 0.82, blue: 1.0).opacity(0.5), radius: screenHeight * 0.02)
    }
}

#Preview {
    JournalEmptyStateView()
        .mainBackground()
}
