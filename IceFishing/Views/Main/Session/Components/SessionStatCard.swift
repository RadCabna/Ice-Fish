import SwiftUI

struct SessionStatCard: View {
    let iconName: String
    let iconColor: Color
    let value: String
    let title: String
    var valueColor: Color = .white

    var body: some View {
        VStack(spacing: screenHeight * 0.006) {
            Image(systemName: iconName)
                .font(.system(size: screenHeight * 0.018))
                .foregroundStyle(iconColor)

            Text(value)
                .font(.system(size: screenHeight * 0.018, weight: .bold))
                .foregroundStyle(valueColor)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(title)
                .font(.system(size: screenHeight * 0.012))
                .foregroundStyle(Color.white.opacity(0.55))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, screenHeight * 0.012)
        .sessionCardStyle(cornerRadius: screenHeight * 0.014)
    }
}

#Preview {
    HStack {
        SessionStatCard(
            iconName: "clock.fill",
            iconColor: Color(red: 0.35, green: 0.85, blue: 1.0),
            value: "34:55",
            title: "Time"
        )
        SessionStatCard(
            iconName: "gauge.with.dots.needle.33percent",
            iconColor: Color(red: 1.0, green: 0.55, blue: 0.2),
            value: "100%",
            title: "Frost"
        )
    }
    .padding()
    .mainBackground()
}
