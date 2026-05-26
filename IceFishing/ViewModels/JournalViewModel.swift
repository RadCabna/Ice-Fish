import Foundation

@MainActor
final class JournalViewModel: ObservableObject {
    @Published private(set) var sessions: [JournalSessionRecord] = []
    @Published var selectedFilter: JournalFilter = .all
    @Published var selectedSession: JournalSessionRecord?
    @Published var sessionPendingDeletion: JournalSessionRecord?

    private let storageKey = "journalSessions"

    var filteredSessions: [JournalSessionRecord] {
        sessions.filter { $0.matches(filter: selectedFilter) }
    }

    var isEmpty: Bool {
        sessions.isEmpty
    }

    var isFilteredListEmpty: Bool {
        filteredSessions.isEmpty
    }

    init(loadStoredSessions: Bool = true) {
        if loadStoredSessions {
            loadSessions()
        }
    }

    func addSession(summary: SessionSummary, config: SessionConfig, note: String? = nil) {
        let record = JournalSessionRecord(summary: summary, config: config, note: note)
        sessions.insert(record, at: 0)
        persistSessions()
    }

    func deleteSession(_ record: JournalSessionRecord) {
        sessions.removeAll { $0.id == record.id }
        if selectedSession?.id == record.id {
            selectedSession = nil
        }
        persistSessions()
    }

    func selectSession(_ record: JournalSessionRecord) {
        selectedSession = record
    }

    func closeSessionDetails() {
        selectedSession = nil
    }

    func requestSessionDeletion(_ record: JournalSessionRecord) {
        sessionPendingDeletion = record
    }

    func cancelSessionDeletion() {
        sessionPendingDeletion = nil
    }

    func confirmSessionDeletion() {
        guard let record = sessionPendingDeletion else { return }
        deleteSession(record)
        sessionPendingDeletion = nil
    }

    func clearAllSessions() {
        sessions = []
        selectedSession = nil
        sessionPendingDeletion = nil
        persistSessions()
    }

    private func loadSessions() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([JournalSessionRecord].self, from: data) else {
            return
        }
        sessions = decoded
    }

    private func persistSessions() {
        guard let data = try? JSONEncoder().encode(sessions) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
