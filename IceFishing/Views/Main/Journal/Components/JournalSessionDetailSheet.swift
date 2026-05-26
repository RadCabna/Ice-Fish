import SwiftUI

struct JournalSessionDetailSheet: View {
    let record: JournalSessionRecord
    let onClose: () -> Void

    private var balanceValue: String {
        if record.summary.balance >= 0 {
            return String(format: "$%.2f", record.summary.balance)
        }
        return String(format: "-$%.2f", abs(record.summary.balance))
    }

    private var balanceColor: Color {
        record.summary.balance >= 0
            ? Color(red: 0.35, green: 0.95, blue: 0.55)
            : Color(red: 1.0, green: 0.38, blue: 0.38)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.1, blue: 0.24),
                    Color(red: 0.12, green: 0.52, blue: 0.78)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer(minLength: screenHeight * 0.1)

                cardContent

                Spacer(minLength: screenHeight * 0.1)
            }
            .padding(.horizontal, screenWidth * 0.06)
        }
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.022) {
            Text("Session Details")
                .font(.system(size: screenHeight * 0.024, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: screenHeight * 0.02) {
                detailRow(title: "Final Balance", value: balanceValue, valueColor: balanceColor)
                detailRow(title: "Duration", value: durationLabel)
                detailRow(title: "Frost Peak", value: "\(record.summary.frostPeakPercent)%")
                detailRow(title: "Stop-Loss", value: String(format: "$%.0f", record.stopLoss))
                detailRow(title: "Take-Profit", value: String(format: "$%.0f", record.takeProfit))
                detailRow(title: "Total Catches", value: "\(record.summary.totalCatchCount)")
            }
            .padding(.top, screenHeight * 0.006)

            Button(action: onClose) {
                Text("Close")
                    .font(.system(size: screenHeight * 0.02, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: screenHeight * 0.058)
                    .background {
                        RoundedRectangle(cornerRadius: screenHeight * 0.014, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.28, green: 0.72, blue: 0.98),
                                        Color(red: 0.14, green: 0.48, blue: 0.88)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
            }
            .buttonStyle(.plain)
            .padding(.top, screenHeight * 0.01)
        }
        .padding(.horizontal, screenWidth * 0.055)
        .padding(.vertical, screenHeight * 0.028)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                .fill(Color(red: 0.08, green: 0.14, blue: 0.28).opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: screenHeight * 0.0012)
        )
    }

    private var durationLabel: String {
        let minutes = max(1, record.summary.durationSeconds / 60)
        return minutes == 1 ? "1 minutes" : "\(minutes) minutes"
    }

    private func detailRow(title: String, value: String, valueColor: Color = .white) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(size: screenHeight * 0.017))
                .foregroundStyle(Color.white.opacity(0.55))

            Spacer(minLength: screenWidth * 0.04)

            Text(value)
                .font(.system(size: screenHeight * 0.017, weight: .semibold))
                .foregroundStyle(valueColor)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    JournalSessionDetailSheet(
        record: JournalSessionRecord(
            summary: SessionSummary(
                balance: 55,
                durationSeconds: 60,
                frostPeakPercent: 0,
                bigCatchCount: 1,
                bonusCount: 1,
                smallCatchCount: 1,
                endedAt: Date()
            ),
            config: SessionConfig(stopLoss: 10, takeProfit: 20, timerMinutes: 30)
        ),
        onClose: {}
    )
}
