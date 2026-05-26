import Foundation
import SwiftUI

@MainActor
final class RulesViewModel: ObservableObject {
    @Published var sessionRemindersEnabled: Bool {
        didSet {
            persist(sessionRemindersEnabled, forKey: Keys.sessionReminders)
            applyRuleNotifications()
        }
    }

    @Published var breakRemindersEnabled: Bool {
        didSet {
            persist(breakRemindersEnabled, forKey: Keys.breakReminders)
            applyRuleNotifications()
        }
    }

    @Published var responsibleQuotesEnabled: Bool {
        didSet {
            persist(responsibleQuotesEnabled, forKey: Keys.responsibleQuotes)
            applyRuleNotifications()
        }
    }

    private enum Keys {
        static let sessionReminders = "rules_sessionReminders"
        static let breakReminders = "rules_breakReminders"
        static let responsibleQuotes = "rules_responsibleQuotes"
    }

    init() {
        sessionRemindersEnabled = UserDefaults.standard.object(forKey: Keys.sessionReminders) as? Bool ?? true
        breakRemindersEnabled = UserDefaults.standard.object(forKey: Keys.breakReminders) as? Bool ?? true
        responsibleQuotesEnabled = UserDefaults.standard.object(forKey: Keys.responsibleQuotes) as? Bool ?? true
        applyRuleNotifications()
    }

    func binding(for itemId: String) -> Binding<Bool>? {
        switch itemId {
        case "sessionReminders":
            return Binding(
                get: { self.sessionRemindersEnabled },
                set: { self.sessionRemindersEnabled = $0 }
            )
        case "breakReminders":
            return Binding(
                get: { self.breakRemindersEnabled },
                set: { self.breakRemindersEnabled = $0 }
            )
        case "responsibleQuotes":
            return Binding(
                get: { self.responsibleQuotesEnabled },
                set: { self.responsibleQuotesEnabled = $0 }
            )
        default:
            return nil
        }
    }

    private func applyRuleNotifications() {
        NotificationManager.shared.syncRuleNotifications(
            sessionReminders: sessionRemindersEnabled,
            breakReminders: breakRemindersEnabled,
            responsibleQuotes: responsibleQuotesEnabled
        )
    }

    private func persist(_ value: Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
