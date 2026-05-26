import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            OnboardingBackground()

            VStack(spacing: 0) {
                pageContent
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)

                bottomBar
            }
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private var pageContent: some View {
        switch viewModel.currentPage {
        case .intro:
            OnboardingIntroView()
        case .session:
            OnboardingSessionView(viewModel: viewModel)
        case .frost:
            OnboardingFrostView(viewModel: viewModel)
        case .responsible:
            OnboardingResponsibleView(viewModel: viewModel)
        }
    }

    private var bottomBar: some View {
        VStack(spacing: screenHeight * 0.016) {
            OnboardingGradientButton(
                title: viewModel.primaryButtonTitle,
                isEnabled: isPrimaryButtonEnabled
            ) {
                handlePrimaryAction()
            }

            OnboardingPageIndicator(
                currentPage: viewModel.currentPageIndex,
                totalPages: viewModel.totalPages
            )
            .padding(.top, screenHeight * 0.005)
        }
        .padding(.horizontal, screenWidth * 0.062)
        .padding(.bottom, screenHeight * 0.045)
    }

    private var isPrimaryButtonEnabled: Bool {
        if viewModel.isLastPage {
            return viewModel.canStartFishing
        }
        return true
    }

    private func handlePrimaryAction() {
        if viewModel.isLastPage {
            guard viewModel.canStartFishing else { return }
            onComplete()
        } else {
            if viewModel.currentPage == .frost {
                viewModel.stopFrostDemoCycle()
            }
            viewModel.advance()
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
