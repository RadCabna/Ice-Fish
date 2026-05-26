import SwiftUI

struct OnboardingFrostView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Text("Watch The Frost")
                .font(.system(size: screenHeight * 0.032, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, screenHeight * 0.07)
                .padding(.horizontal, screenWidth * 0.062)

            Spacer()
                .frame(height: screenHeight * 0.06)

            frostLevelCard

            Text("The closer you are to your limits — the colder the interface becomes.")
                .font(.system(size: screenHeight * 0.018))
                .foregroundStyle(.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .padding(.horizontal, screenWidth * 0.082)
                .padding(.top, screenHeight * 0.028)

            Spacer()

            FrostMeterView(progress: viewModel.displayedFrostProgress)
                .padding(.horizontal, screenWidth * 0.062)
                .padding(.bottom, screenHeight * 0.02)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.startFrostDemoCycle()
        }
        .onDisappear {
            viewModel.stopFrostDemoCycle()
        }
    }

    private var frostLevelCard: some View {
        VStack(spacing: screenHeight * 0.009) {
            AnimatablePercentText(
                value: viewModel.displayedFrostPercent,
                fontSize: screenHeight * 0.09
            )

            Text("Frost Level")
                .font(.system(size: screenHeight * 0.024, weight: .medium))
                .foregroundStyle(.white.opacity(0.75))
        }
        .frame(width: screenWidth * 0.72, height: screenWidth * 0.72)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.024, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: screenHeight * 0.024, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: screenHeight * 0.0012)
        )
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true, appliesPadding: false) {
        OnboardingFrostView(viewModel: OnboardingViewModel())
    }
}
