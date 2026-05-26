import SwiftUI

struct OnboardingSessionView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Control Your Session")
                .font(.system(size: screenHeight * 0.032, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, screenHeight * 0.07)
                .padding(.horizontal, screenWidth * 0.062)

            VStack(spacing: screenHeight * 0.014) {
                SessionControlCard(
                    iconName: "timerIcon",
                    iconColor: Color(red: 0.35, green: 0.65, blue: 1.0),
                    title: "Session Timer",
                    value: viewModel.sessionTimer
                )
                SessionControlCard(
                    iconName: "stopIcon",
                    iconColor: Color(red: 1.0, green: 0.35, blue: 0.35),
                    title: "Stop-Loss",
                    value: viewModel.stopLoss
                )
                SessionControlCard(
                    iconName: "profitIcon",
                    iconColor: Color(red: 0.35, green: 0.9, blue: 0.55),
                    title: "Take-Profit",
                    value: viewModel.takeProfit
                )
                SessionControlCard(
                    iconName: "frostIcon",
                    iconColor: Color(red: 1.0, green: 0.55, blue: 0.2),
                    title: "Frost Warning",
                    value: viewModel.frostWarning
                )
            }
            .padding(.horizontal, screenWidth * 0.062)
            .padding(.top, screenHeight * 0.028)

            Text("Track time, losses, bonuses, and emotional pressure in real time.")
                .font(.system(size: screenHeight * 0.018))
                .foregroundStyle(.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, screenWidth * 0.082)
                .padding(.top, screenHeight * 0.022)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true, appliesPadding: false) {
        OnboardingSessionView(viewModel: OnboardingViewModel())
    }
}
