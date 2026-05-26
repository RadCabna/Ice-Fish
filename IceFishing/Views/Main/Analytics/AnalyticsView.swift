import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var journalViewModel: JournalViewModel
    @State private var snapshot = AnalyticsSnapshot.make(from: [])

    private var horizontalInset: CGFloat {
        screenWidth * 0.05
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: screenHeight * 0.018) {
                header

                AnalyticsPanel(title: "Echo Sounder") {
                    EchoSounderView(blipStrengths: snapshot.sonarBlipStrengths)
                }

                AnalyticsPanel(title: "Bankroll Movement") {
                    if snapshot.bankrollPoints.isEmpty {
                        emptyChartPlaceholder("Complete sessions to see bankroll movement.")
                    } else {
                        BankrollMovementChart(
                            points: snapshot.bankrollPoints,
                            yMax: snapshot.bankrollYMax
                        )
                    }
                }

                AnalyticsPanel(title: "Catch Distribution") {
                    if snapshot.sessions.isEmpty {
                        emptyChartPlaceholder("Log catches to build distribution.")
                    } else {
                        CatchDistributionChart(values: snapshot.catchDistribution)
                    }
                }

                AnalyticsPanel(title: "Frost Statistics") {
                    FrostStatisticsCard(snapshot: snapshot)
                }

                AnalyticsPanel(title: "Insights") {
                    AnalyticsInsightCard(text: snapshot.insightText)
                }
            }
            .padding(.horizontal, horizontalInset)
            .padding(.bottom, screenHeight * 0.12)
        }
        .scrollContentBackground(.hidden)
        .mainBackground()
        .navigationBarHidden(true)
        .colorScheme(.dark)
        .onAppear {
            reloadSnapshot()
        }
        .onChange(of: journalViewModel.sessions.count) { _, _ in
            reloadSnapshot()
        }
        .onChange(of: journalViewModel.sessions.map(\.id)) { _, _ in
            reloadSnapshot()
        }
    }

    private func reloadSnapshot() {
        snapshot = AnalyticsSnapshot.make(from: journalViewModel.sessions)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.006) {
            Text("Echo Sounder")
                .font(.system(size: screenHeight * 0.034, weight: .bold))
                .foregroundStyle(.white)

            Text("Performance analytics")
                .font(.system(size: screenHeight * 0.016))
                .foregroundStyle(Color.white.opacity(0.55))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, screenHeight * 0.02)
    }

    private func emptyChartPlaceholder(_ message: String) -> some View {
        Text(message)
            .font(.system(size: screenHeight * 0.014))
            .foregroundStyle(Color.white.opacity(0.45))
            .frame(maxWidth: .infinity, minHeight: screenHeight * 0.12)
    }
}

#Preview {
    let journal = JournalViewModel(loadStoredSessions: false)
    journal.addSession(
        summary: SessionSummary(
            balance: 55,
            durationSeconds: 60,
            frostPeakPercent: 12,
            bigCatchCount: 1,
            bonusCount: 1,
            smallCatchCount: 1,
            endedAt: Date().addingTimeInterval(-86400 * 2)
        ),
        config: SessionConfig(stopLoss: 10, takeProfit: 20, timerMinutes: 30)
    )
    journal.addSession(
        summary: SessionSummary(
            balance: 35,
            durationSeconds: 120,
            frostPeakPercent: 33,
            bigCatchCount: 0,
            bonusCount: 2,
            smallCatchCount: 2,
            endedAt: Date().addingTimeInterval(-86400)
        ),
        config: SessionConfig(stopLoss: 10, takeProfit: 20, timerMinutes: 30)
    )
    journal.addSession(
        summary: SessionSummary(
            balance: -15,
            durationSeconds: 45,
            frostPeakPercent: 85,
            bigCatchCount: 0,
            bonusCount: 0,
            smallCatchCount: 1,
            endedAt: Date()
        ),
        config: SessionConfig(stopLoss: 10, takeProfit: 20, timerMinutes: 30)
    )

    return AnalyticsView(journalViewModel: journal)
}
