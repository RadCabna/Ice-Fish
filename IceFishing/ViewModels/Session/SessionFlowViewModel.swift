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
        if !path.isEmpty {
            path.removeLast()
        }
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
        KeyboardDismiss.dismiss()
        liveViewModel?.stop()
        liveViewModel = nil
        pendingSessionConfig = nil

        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            path = NavigationPath()
        }

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(400))
            setupViewModel.resetForm()
        }
    }

    func updateDefaultDuration(_ minutes: Int) {
        setupViewModel.setDefaultDuration(minutes)
    }

    func resetSetupFormOnTabEntry() {
        guard path.isEmpty, liveViewModel == nil else { return }
        setupViewModel.resetForm()
    }
}
