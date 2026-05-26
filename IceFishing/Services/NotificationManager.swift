import Foundation
import UserNotifications

enum RuleNotificationType: String, CaseIterable {
    case sessionReminders = "icefishing.rules.sessionReminders"
    case breakReminders = "icefishing.rules.breakReminders"
    case responsibleQuotes = "icefishing.rules.responsibleQuotes"

    var notificationTitle: String {
        "IceFishing"
    }

    var notificationBody: String {
        switch self {
        case .sessionReminders:
            return "Check your stop-loss and take-profit before the next session."
        case .breakReminders:
            return "Take a break between sessions to reset and stay in control."
        case .responsibleQuotes:
            return "Fish mindfully: set limits and stop when it is no longer fun."
        }
    }

    var scheduledHour: Int {
        switch self {
        case .sessionReminders:
            return 17
        case .breakReminders:
            return 20
        case .responsibleQuotes:
            return 10
        }
    }

}

@MainActor
final class NotificationManager {
    static let shared = NotificationManager()

    private let settingsDailyID = "icefishing.settings.daily"

    private init() {}

    // MARK: - Settings

    func setNotificationsEnabled(_ enabled: Bool) {
        if enabled {
            requestAuthorization { [weak self] granted in
                guard granted, let self else { return }
                self.scheduleSettingsDailyReminder()
            }
        } else {
            cancelNotification(id: settingsDailyID)
        }
    }

    // MARK: - Rules

    func syncRuleNotifications(
        sessionReminders: Bool,
        breakReminders: Bool,
        responsibleQuotes: Bool
    ) {
        updateRuleNotification(.sessionReminders, enabled: sessionReminders)
        updateRuleNotification(.breakReminders, enabled: breakReminders)
        updateRuleNotification(.responsibleQuotes, enabled: responsibleQuotes)
    }

    private func updateRuleNotification(_ type: RuleNotificationType, enabled: Bool) {
        if enabled {
            requestAuthorization { [weak self] granted in
                guard granted, let self else { return }
                self.scheduleRuleNotification(type)
            }
        } else {
            cancelNotification(id: type.rawValue)
        }
    }

    // MARK: - Scheduling

    private func scheduleSettingsDailyReminder() {
        cancelNotification(id: settingsDailyID)

        let content = UNMutableNotificationContent()
        content.title = "IceFishing"
        content.body = "Review your limits before starting a new session."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 18
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: settingsDailyID,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    private func scheduleRuleNotification(_ type: RuleNotificationType) {
        cancelNotification(id: type.rawValue)

        let content = UNMutableNotificationContent()
        content.title = type.notificationTitle
        content.body = type.notificationBody
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = type.scheduledHour
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: type.rawValue,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    private func cancelNotification(id: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [id])
        center.removeDeliveredNotifications(withIdentifiers: [id])
    }

    private func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            Task { @MainActor in
                completion(granted)
            }
        }
    }
}
