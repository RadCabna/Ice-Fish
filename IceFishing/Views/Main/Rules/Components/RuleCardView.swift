import SwiftUI

struct RuleCardView: View {
    let rule: FishingRule

    private var iconContainerSize: CGFloat {
        screenHeight * 0.052
    }

    private var cornerRadius: CGFloat {
        screenHeight * 0.016
    }

    var body: some View {
        HStack(alignment: .top, spacing: screenWidth * 0.04) {
            ZStack {
                RoundedRectangle(cornerRadius: screenHeight * 0.012, style: .continuous)
                    .fill(rule.iconColor.opacity(0.22))

                Image(rule.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: screenHeight * 0.028,
                        height: screenHeight * 0.028
                    )
            }
            .frame(width: iconContainerSize, height: iconContainerSize)

            VStack(alignment: .leading, spacing: screenHeight * 0.008) {
                Text(rule.title)
                    .font(.system(size: screenHeight * 0.017, weight: .semibold))
                    .foregroundStyle(.white)

                Text(rule.description)
                    .font(.system(size: screenHeight * 0.014))
                    .foregroundStyle(Color.white.opacity(0.55))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, screenWidth * 0.045)
        .padding(.vertical, screenHeight * 0.016)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color(red: 0.1, green: 0.16, blue: 0.28))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: screenHeight * 0.0012)
        )
    }
}

#Preview {
    VStack {
        RuleCardView(rule: FishingRule.winterRules[0])
    }
    .padding()
    .mainBackground()
}
