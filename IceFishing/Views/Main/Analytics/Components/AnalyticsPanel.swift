import SwiftUI

struct AnalyticsPanel<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    private var cornerRadius: CGFloat {
        screenHeight * 0.016
    }

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.014) {
            Text(title)
                .font(.system(size: screenHeight * 0.018, weight: .semibold))
                .foregroundStyle(.white)

            content()
        }
        .padding(.horizontal, screenWidth * 0.045)
        .padding(.vertical, screenHeight * 0.018)
        .frame(maxWidth: .infinity, alignment: .leading)
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
