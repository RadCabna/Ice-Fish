import SwiftUI

struct SessionSetupView: View {
    @ObservedObject var viewModel: SessionSetupViewModel
    let onStart: () -> Void

    private var horizontalInset: CGFloat {
        screenWidth * 0.05
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: screenHeight * 0.02) {
                header
                    .padding(.horizontal, horizontalInset)

                drillHero

                VStack(spacing: screenHeight * 0.02) {
                    SessionAmountField(
                        title: "Stop-Loss Amount",
                        placeholder: "$ 0.00",
                        text: $viewModel.stopLossText,
                        onChange: { viewModel.triggerDotPulse() }
                    )

                    SessionAmountField(
                        title: "Take-Profit Goal",
                        placeholder: "$ 0.00",
                        text: $viewModel.takeProfitText,
                        onChange: { viewModel.triggerDotPulse() }
                    )

                    timerCard

                    Text("Play responsibly. Set limits. Stop if the game stops being fun.")
                        .font(.system(size: screenHeight * 0.014))
                        .foregroundStyle(Color.white.opacity(0.45))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, screenWidth * 0.06)

                    SessionDrillButton(
                        title: "Drill The Hole",
                        isEnabled: viewModel.canStartSession,
                        action: onStart
                    )
                }
                .padding(.horizontal, horizontalInset)
            }
            .padding(.top, screenHeight * 0.02)
            .padding(.bottom, screenHeight * 0.03)
        }
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarHidden(true)
        .colorScheme(.dark)
    }

    private var header: some View {
        VStack(spacing: screenHeight * 0.008) {
            Text("Drill The Ice")
                .font(.system(size: screenHeight * 0.034, weight: .bold))
                .foregroundStyle(.white)

            Text("Set your limits before starting")
                .font(.system(size: screenHeight * 0.018))
                .foregroundStyle(Color.white.opacity(0.55))
        }
        .frame(maxWidth: .infinity)
    }

    private var drillHero: some View {
        SessionDrillHeroView(pulseToken: viewModel.dotPulseToken)
            .id("sessionDrillHero")
    }

    private var timerCard: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.014) {
            HStack {
                Text("Session Timer")
                    .font(.system(size: screenHeight * 0.016))
                    .foregroundStyle(Color.white.opacity(0.55))

                Spacer()

                Text(viewModel.timerLabel)
                    .font(.system(size: screenHeight * 0.018, weight: .semibold))
                    .foregroundStyle(.white)
            }

            Slider(
                value: $viewModel.timerMinutes,
                in: viewModel.timerRange,
                step: viewModel.timerStep
            )
            .tint(Color(red: 0.2, green: 0.75, blue: 0.95))
            .onChange(of: viewModel.timerMinutes) { _, _ in
                viewModel.triggerDotPulse()
            }

            Text("Sessions longer than 30 minutes reduce concentration.")
                .font(.system(size: screenHeight * 0.013))
                .foregroundStyle(Color.white.opacity(0.4))
        }
        .padding(screenWidth * 0.04)
        .sessionCardStyle()
    }
}

#Preview {
    ZStack {
        MainBackground()
        SessionSetupView(viewModel: SessionSetupViewModel(), onStart: {})
    }
}
