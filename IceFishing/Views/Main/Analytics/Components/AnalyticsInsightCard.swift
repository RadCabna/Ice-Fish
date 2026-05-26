import SwiftUI

struct AnalyticsInsightCard: View {
    let text: String

    private let accent = Color(red: 0.35, green: 0.88, blue: 1.0)

    var body: some View {
        Text(text)
            .font(.system(size: screenHeight * 0.015))
            .foregroundStyle(accent.opacity(0.9))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
