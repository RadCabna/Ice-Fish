import SwiftUI

struct FrostStatisticsCard: View {
    let snapshot: AnalyticsSnapshot

    private var items: [FrostStatItem] {
        [
            FrostStatItem(
                id: "avgFrost",
                iconName: "frostIcon",
                iconColorName: .orange,
                title: "Average Frost",
                value: "\(snapshot.averageFrostPercent)%"
            ),
            FrostStatItem(
                id: "longest",
                iconName: "timerIcon",
                iconColorName: .cyan,
                title: "Longest Session",
                value: "\(snapshot.longestSessionMinutes) min"
            ),
            FrostStatItem(
                id: "dangerous",
                iconName: "dangerIcon",
                iconColorName: .red,
                title: "Dangerous Sessions",
                value: "\(snapshot.dangerousSessionsCount)"
            ),
            FrostStatItem(
                id: "total",
                iconName: "totalIcon",
                iconColorName: .purple,
                title: "Total Sessions",
                value: "\(snapshot.totalSessionsCount)"
            )
        ]
    }

    var body: some View {
        VStack(spacing: screenHeight * 0.016) {
            ForEach(items) { item in
                HStack(spacing: screenWidth * 0.035) {
                    Image(item.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenHeight * 0.026, height: screenHeight * 0.026)

                    Text(item.title)
                        .font(.system(size: screenHeight * 0.016))
                        .foregroundStyle(.white)

                    Spacer()

                    Text(item.value)
                        .font(.system(size: screenHeight * 0.016, weight: .semibold))
                        .foregroundStyle(color(for: item.iconColorName))
                }
            }
        }
    }

    private func color(for name: AnalyticsIconColor) -> Color {
        switch name {
        case .orange:
            return Color(red: 1.0, green: 0.62, blue: 0.25)
        case .cyan:
            return Color(red: 0.4, green: 0.85, blue: 1.0)
        case .red:
            return Color(red: 1.0, green: 0.38, blue: 0.38)
        case .purple:
            return Color(red: 0.72, green: 0.55, blue: 1.0)
        }
    }
}
