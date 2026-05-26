import SwiftUI

struct RulesView: View {
    @StateObject private var viewModel = RulesViewModel()

    private var horizontalInset: CGFloat {
        screenWidth * 0.05
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: screenHeight * 0.018) {
                header

                VStack(spacing: screenHeight * 0.012) {
                    ForEach(FishingRule.winterRules) { rule in
                        RuleCardView(rule: rule)
                    }
                }

                ResponsiblePlayCard()

                RulesNotificationsCard(viewModel: viewModel)
            }
            .padding(.horizontal, horizontalInset)
            .padding(.bottom, screenHeight * 0.12)
        }
        .scrollContentBackground(.hidden)
        .mainBackground()
        .navigationBarHidden(true)
        .colorScheme(.dark)
    }

    private var header: some View {
        VStack(spacing: screenHeight * 0.008) {
            Text("Winter Fishing Rules")
                .font(.system(size: screenHeight * 0.034, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text("Essential guidelines for safe fishing")
                .font(.system(size: screenHeight * 0.016))
                .foregroundStyle(Color.white.opacity(0.55))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, screenHeight * 0.02)
        .padding(.bottom, screenHeight * 0.006)
    }
}

#Preview {
    RulesView()
}
