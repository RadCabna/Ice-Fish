import SwiftUI

struct JournalView: View {
    @ObservedObject var viewModel: JournalViewModel

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: screenHeight * 0.018) {
                    header

                    JournalFilterBar(selectedFilter: $viewModel.selectedFilter)

                    if viewModel.isEmpty {
                        JournalEmptyStateView()
                    } else if viewModel.isFilteredListEmpty {
                        filteredEmptyState
                    } else {
                        sessionList
                    }
                }
                .padding(.bottom, screenHeight * 0.12)
            }
            .scrollContentBackground(.hidden)

            if viewModel.sessionPendingDeletion != nil {
                AppConfirmationAlert(
                    title: "Delete Session?",
                    message: "This session will be removed from your journal.",
                    confirmTitle: "Delete",
                    onConfirm: { viewModel.confirmSessionDeletion() },
                    onCancel: { viewModel.cancelSessionDeletion() }
                )
            }
        }
        .mainBackground()
        .navigationBarHidden(true)
        .fullScreenCover(item: selectedSessionBinding) { record in
            JournalSessionDetailSheet(record: record) {
                viewModel.closeSessionDetails()
            }
        }
    }

    private var selectedSessionBinding: Binding<JournalSessionRecord?> {
        Binding(
            get: { viewModel.selectedSession },
            set: { viewModel.selectedSession = $0 }
        )
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.006) {
            Text("Fisherman Journal")
                .font(.system(size: screenHeight * 0.034, weight: .bold))
                .foregroundStyle(.white)

            Text("Session history")
                .font(.system(size: screenHeight * 0.016))
                .foregroundStyle(Color.white.opacity(0.55))
        }
        .padding(.horizontal, screenWidth * 0.05)
        .padding(.top, screenHeight * 0.02)
    }

    private var filteredEmptyState: some View {
        Text("No sessions match this filter.")
            .font(.system(size: screenHeight * 0.016))
            .foregroundStyle(Color.white.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.top, screenHeight * 0.1)
    }

    private var sessionList: some View {
        LazyVStack(spacing: screenHeight * 0.018) {
            ForEach(viewModel.filteredSessions) { record in
                JournalSessionCard(
                    record: record,
                    onTap: { viewModel.selectSession(record) },
                    onDelete: { viewModel.requestSessionDeletion(record) }
                )
            }
        }
        .padding(.horizontal, screenWidth * 0.05)
    }
}

#Preview("Empty") {
    NavigationStack {
        JournalView(viewModel: JournalViewModel(loadStoredSessions: false))
    }
}

#Preview("With Sessions") {
    let viewModel = JournalViewModel(loadStoredSessions: false)
    viewModel.addSession(
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
    )

    return NavigationStack {
        JournalView(viewModel: viewModel)
    }
}
