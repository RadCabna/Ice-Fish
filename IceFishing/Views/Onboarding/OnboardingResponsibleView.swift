import SwiftUI

struct OnboardingResponsibleView: View {
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: 0) {
            Image("onboardingIcon_4")
                .resizable()
                .scaledToFit()
                .frame(
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.1
                )
                .padding(.top, screenHeight * 0.08)

            Text("Fish Responsibly")
                .font(.system(size: screenHeight * 0.032, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, screenHeight * 0.02)

            Text("Responsible play starts with awareness.")
                .font(.system(size: screenHeight * 0.018))
                .foregroundStyle(.white.opacity(0.65))
                .padding(.top, screenHeight * 0.009)

            Spacer()
                .frame(height: screenHeight * 0.04)

            ageConfirmationSection

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.resetAgeConfirmation()
        }
    }

    private var ageConfirmationSection: some View {
        ZStack {
            radarRings

            ageConfirmationButton
                .offset(y:-screenHeight*0.1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: screenHeight * 0.42)
    }

    private var ageConfirmationButton: some View {
        Button {
            viewModel.confirmAge()
        } label: {
            VStack(spacing: screenHeight * 0.01) {
                Text("I am 18 years or older")
                    .font(.system(size: screenHeight * 0.019, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text("Gambling involves financial risk.")
                    .font(.system(size: screenHeight * 0.016))
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, screenWidth * 0.055)
            .padding(.vertical, screenHeight * 0.028)
            .frame(maxWidth: screenWidth * 0.76)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                    .stroke(
                        viewModel.hasConfirmedAge
                            ? Color("buttonColor_2").opacity(0.7)
                            : Color.white.opacity(0.12),
                        lineWidth: screenHeight * (viewModel.hasConfirmedAge ? 0.002 : 0.0012)
                    )
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Confirm you are 18 years or older")
        .accessibilityAddTraits(viewModel.hasConfirmedAge ? .isSelected : [])
    }

    private var radarRings: some View {
        ZStack {
            ForEach([1.0, 0.78, 0.56], id: \.self) { scale in
                Circle()
                    .stroke(Color("buttonColor_2").opacity(0.52), lineWidth: screenHeight * 0.0015)
                    .frame(
                        width: screenWidth * 0.9 * scale,
                        height: screenWidth * 0.9 * scale
                    )
            }
        }
        .opacity(0.55)
        .allowsHitTesting(false)
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true, appliesPadding: false) {
        OnboardingResponsibleView(viewModel: OnboardingViewModel())
    }
}
