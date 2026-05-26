import SwiftUI

struct SessionView: View {
    @StateObject private var flowViewModel = SessionFlowViewModel()
    @StateObject private var journalViewModel = JournalViewModel(loadStoredSessions: false)
    @StateObject private var tabViewModel = MainTabViewModel()

    var body: some View {
        SessionFlowContainer(
            flowViewModel: flowViewModel,
            journalViewModel: journalViewModel,
            tabViewModel: tabViewModel
        )
    }
}

#Preview {
    SessionView()
}
