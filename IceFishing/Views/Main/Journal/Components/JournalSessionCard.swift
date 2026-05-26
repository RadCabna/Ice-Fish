import SwiftUI

struct JournalSessionCard: View {
    let record: JournalSessionRecord
    let onTap: () -> Void
    let onDelete: () -> Void

    private var balanceColor: Color {
        record.summary.balance >= 0
            ? Color(red: 0.35, green: 0.95, blue: 0.55)
            : Color(red: 1.0, green: 0.38, blue: 0.38)
    }

    private var cardCornerRadius: CGFloat {
        screenHeight * 0.018
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            Button(action: onTap) {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(
                        RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Session \(record.formattedDate), \(record.summary.formattedBalance)")
            .accessibilityHint("Opens session details")

            cardContent
        }
        .background(
            RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
                .fill(Color(red: 0.1, green: 0.16, blue: 0.28))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cardCornerRadius, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: screenHeight * 0.0012)
        )
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: screenHeight * 0.02) {
                HStack(alignment: .top) {
                    Text(record.formattedDate)
                        .font(.system(size: screenHeight * 0.015))
                        .foregroundStyle(Color.white.opacity(0.55))
                        .multilineTextAlignment(.leading)

                    Spacer(minLength: screenWidth * 0.04)

                    Text(record.summary.formattedBalance)
                        .font(.system(size: screenHeight * 0.022, weight: .semibold))
                        .foregroundStyle(balanceColor)
                }

                HStack(spacing: screenWidth * 0.055) {
                    metricItem(
                        iconName: "timerIcon",
                        value: record.formattedDuration,
                        color: Color(red: 0.4, green: 0.85, blue: 1.0)
                    )
                    metricItem(
                        iconName: "frostIcon",
                        value: "\(record.summary.frostPeakPercent)%",
                        color: Color(red: 1.0, green: 0.62, blue: 0.25)
                    )
                    metricItem(
                        iconName: "profitIcon",
                        value: "\(record.summary.totalCatchCount)",
                        color: Color(red: 0.72, green: 0.55, blue: 1.0)
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .allowsHitTesting(false)

            Rectangle()
                .fill(Color.white.opacity(0.12))
                .frame(height: screenHeight * 0.0012)
                .padding(.top, screenHeight * 0.018)
                .padding(.bottom, screenHeight * 0.014)
                .allowsHitTesting(false)

            Button(action: onDelete) {
                HStack(spacing: screenWidth * 0.02) {
                    Image(systemName: "trash")
                        .font(.system(size: screenHeight * 0.013, weight: .semibold))

                    Text("Delete")
                        .font(.system(size: screenHeight * 0.013, weight: .medium))
                }
                .foregroundStyle(Color.white.opacity(0.88))
                .padding(.horizontal, screenWidth * 0.04)
                .padding(.vertical, screenHeight * 0.009)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.01, style: .continuous)
                        .fill(Color(red: 0.42, green: 0.1, blue: 0.14))
                )
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, screenWidth * 0.055)
        .padding(.vertical, screenHeight * 0.02)
    }

    private func metricItem(iconName: String, value: String, color: Color) -> some View {
        HStack(spacing: screenWidth * 0.018) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: screenHeight * 0.024, height: screenHeight * 0.024)

            Text(value)
                .font(.system(size: screenHeight * 0.017, weight: .semibold))
                .foregroundStyle(color)
        }
    }
}

#Preview {
    JournalSessionCard(
        record: JournalSessionRecord(
            summary: SessionSummary(
                balance: 55,
                durationSeconds: 60,
                frostPeakPercent: 0,
                bigCatchCount: 1,
                bonusCount: 0,
                smallCatchCount: 2,
                endedAt: Date()
            ),
            config: SessionConfig(stopLoss: 10, takeProfit: 20, timerMinutes: 30)
        ),
        onTap: {},
        onDelete: {}
    )
    .padding()
    .mainBackground()
}
