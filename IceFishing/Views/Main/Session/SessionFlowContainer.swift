import SwiftUI

struct SessionFlowContainer: View {
    @ObservedObject var flowViewModel: SessionFlowViewModel
    @ObservedObject var journalViewModel: JournalViewModel
    @ObservedObject var tabViewModel: MainTabViewModel

    var body: some View {
        NavigationStack(path: $flowViewModel.path) {
            ZStack {
                AppBackground()

                SessionSetupView(viewModel: flowViewModel.setupViewModel) {
                    flowViewModel.beginLiveSession()
                }
            }
            .navigationDestination(for: SessionRoute.self) { route in
                switch route {
                case .live:
                    if let liveViewModel = flowViewModel.liveViewModel {
                        ZStack {
                            AppBackground()
                            LiveSessionView(viewModel: liveViewModel) {
                                flowViewModel.finishLiveSession()
                            }
                        }
                    }
                case .complete(let summary):
                    ZStack {
                        AppBackground()
                        SessionCompleteView(
                            summary: summary,
                            onSave: { note in
                                flowViewModel.saveCompletedSession(
                                    to: journalViewModel,
                                    summary: summary,
                                    note: note
                                )
                            },
                            onViewAnalytics: { note in
                                flowViewModel.saveCompletedSession(
                                    to: journalViewModel,
                                    summary: summary,
                                    note: note
                                )
                                withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                                    tabViewModel.selectedTab = .analytics
                                }
                            },
                            onDelete: { flowViewModel.discardCompletedSession() }
                        )
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SessionFlowContainer(
        flowViewModel: SessionFlowViewModel(),
        journalViewModel: JournalViewModel(loadStoredSessions: false),
        tabViewModel: MainTabViewModel()
    )
    .environmentObject(SettingsViewModel())
}
