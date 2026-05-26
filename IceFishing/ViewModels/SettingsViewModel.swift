import Foundation
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var notificationsEnabled: Bool {
        didSet {
            persist(notificationsEnabled, forKey: Keys.notifications)
            NotificationManager.shared.setNotificationsEnabled(notificationsEnabled)
        }
    }

    @Published var soundEffectsEnabled: Bool {
        didSet {
            persist(soundEffectsEnabled, forKey: Keys.soundEffects)
            SoundEffectsManager.shared.setSoundEffectsEnabled(soundEffectsEnabled)
        }
    }

    @Published var darkModeEnabled: Bool {
        didSet { persist(darkModeEnabled, forKey: Keys.darkMode) }
    }

    @Published var defaultSessionMinutes: Int {
        didSet { persist(defaultSessionMinutes, forKey: Keys.defaultDuration) }
    }

    @Published var showsClearHistoryAlert = false

    static let durationOptions = [15, 30, 45, 60]

    private enum Keys {
        static let notifications = "settings_notifications"
        static let soundEffects = "settings_soundEffects"
        static let darkMode = "settings_darkMode"
        static let defaultDuration = "settings_defaultSessionMinutes"
    }

    init() {
        notificationsEnabled = UserDefaults.standard.object(forKey: Keys.notifications) as? Bool ?? true
        soundEffectsEnabled = UserDefaults.standard.object(forKey: Keys.soundEffects) as? Bool ?? true
        darkModeEnabled = UserDefaults.standard.object(forKey: Keys.darkMode) as? Bool ?? true

        let storedDuration = UserDefaults.standard.integer(forKey: Keys.defaultDuration)
        defaultSessionMinutes = Self.durationOptions.contains(storedDuration) ? storedDuration : 30

        NotificationManager.shared.setNotificationsEnabled(notificationsEnabled)
        SoundEffectsManager.shared.setSoundEffectsEnabled(soundEffectsEnabled)
    }

    static func storedDefaultSessionMinutes() -> Double {
        let stored = UserDefaults.standard.integer(forKey: Keys.defaultDuration)
        let minutes = durationOptions.contains(stored) ? stored : 30
        return Double(minutes)
    }

    func requestClearHistory() {
        showsClearHistoryAlert = true
    }

    func cancelClearHistory() {
        showsClearHistoryAlert = false
    }

    private func persist(_ value: Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    private func persist(_ value: Int, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
