import Foundation

enum SoundEffect: String {
    case tap
    case catchMade
    case sessionEnd
}

@MainActor
final class SoundEffectsManager {
    static let shared = SoundEffectsManager()

    private let enabledKey = "settings_soundEffects"
    private(set) var isEnabled: Bool

    private init() {
        isEnabled = UserDefaults.standard.object(forKey: enabledKey) as? Bool ?? true
        SessionAudioManager.shared.setEnabled(isEnabled)
    }

    func setSoundEffectsEnabled(_ enabled: Bool) {
        isEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: enabledKey)
        SessionAudioManager.shared.setEnabled(enabled)
    }

    func play(_ effect: SoundEffect) {
        guard isEnabled else { return }
        // UI sounds can be wired here when assets are added.
    }
}
