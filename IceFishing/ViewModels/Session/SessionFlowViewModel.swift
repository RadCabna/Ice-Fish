import Foundation
import SwiftUI

@MainActor
final class SessionFlowViewModel: ObservableObject {
    @Published var path = NavigationPath()
    let setupViewModel = SessionSetupViewModel()
    @Published private(set) var liveViewModel: LiveSessionViewModel?
    private var pendingSessionConfig: SessionConfig?

    func beginLiveSession() {
        guard let config = setupViewModel.makeConfig() else { return }
        let live = LiveSessionViewModel(config: config)
        live.start()
        liveViewModel = live
        path.append(SessionRoute.live)
    }

    func finishLiveSession() {
        guard let live = liveViewModel else { return }
        live.stop()
        pendingSessionConfig = live.config
        let summary = live.makeSummary()
        path.append(SessionRoute.complete(summary))
    }

    func saveCompletedSession(to journal: JournalViewModel, summary: SessionSummary, note: String) {
        guard let config = pendingSessionConfig else {
            resetToSetup()
            return
        }
        journal.addSession(summary: summary, config: config, note: note.isEmpty ? nil : note)
        pendingSessionConfig = nil
        resetToSetup()
    }

    func discardCompletedSession() {
        pendingSessionConfig = nil
        resetToSetup()
    }

    func resetToSetup() {
        liveViewModel?.stop()
        liveViewModel = nil
        path = NavigationPath()
        setupViewModel.resetForm()
    }

    func updateDefaultDuration(_ minutes: Int) {
        setupViewModel.timerMinutes = Double(minutes)
    }

    func resetSetupFormOnTabEntry() {
        guard path.isEmpty, liveViewModel == nil else { return }
        setupViewModel.resetForm()
    }
}
