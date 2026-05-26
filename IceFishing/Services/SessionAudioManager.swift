import AVFoundation
import Foundation

private enum FrostAudioTier: Equatable {
    case clean
    case hoarfrost
    case heavy

    init(frostPercent: Double) {
        switch frostPercent {
        case ..<41:
            self = .clean
        case ..<71:
            self = .hoarfrost
        default:
            self = .heavy
        }
    }
}

@MainActor
final class SessionAudioManager {
    static let shared = SessionAudioManager()

    private var lightWindPlayer: AVAudioPlayer?
    private var sonarPlayer: AVAudioPlayer?
    private var hardWindPlayer: AVAudioPlayer?
    private var frostCrackPlayer: AVAudioPlayer?

    private var currentTier: FrostAudioTier?
    private var isEnabled = true
    private var isSessionActive = false
    private var hasPlayedIceCrack = false
    private var lastFrostPercent: Double = 0

    private init() {
        configureAudioSession()
    }

    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        if enabled, isSessionActive {
            currentTier = nil
            updateFrostLevel(lastFrostPercent)
        } else {
            stopLoopingSounds()
            frostCrackPlayer?.stop()
        }
    }

    func sessionDidStart() {
        isSessionActive = true
        hasPlayedIceCrack = false
        currentTier = nil
        lastFrostPercent = 0
        preparePlayersIfNeeded()
        updateFrostLevel(0)
    }

    func sessionDidEnd() {
        isSessionActive = false
        currentTier = nil
        hasPlayedIceCrack = false
        lastFrostPercent = 0
        stopAll()
    }

    func updateFrostLevel(_ percent: Double) {
        lastFrostPercent = percent
        guard isSessionActive, isEnabled else { return }

        if percent >= 100 {
            guard !hasPlayedIceCrack else { return }
            hasPlayedIceCrack = true
            currentTier = nil
            stopLoopingSounds()
            playIceCrackOnce()
            return
        }

        let tier = FrostAudioTier(frostPercent: percent)
        guard tier != currentTier else { return }
        currentTier = tier
        applyTier(tier)
    }

    private func applyTier(_ tier: FrostAudioTier) {
        stopLoopingSounds()

        switch tier {
        case .clean:
            playLoop(lightWindPlayer, volume: 0.75)
            playLoop(sonarPlayer, volume: 0.55)
        case .hoarfrost:
            playLoop(hardWindPlayer, volume: 0.8)
        case .heavy:
            playLoop(hardWindPlayer, volume: 1.0)
        }
    }

    private func configureAudioSession() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try? session.setActive(true)
    }

    private func preparePlayersIfNeeded() {
        if lightWindPlayer == nil {
            lightWindPlayer = makeLoopingPlayer(resource: "lightWindSound")
        }
        if sonarPlayer == nil {
            sonarPlayer = makeLoopingPlayer(resource: "sonarSound")
        }
        if hardWindPlayer == nil {
            hardWindPlayer = makeLoopingPlayer(resource: "hsrdWindSound")
        }
        if frostCrackPlayer == nil {
            frostCrackPlayer = makeOneShotPlayer(resource: "frostSound")
        }
    }

    private func makeLoopingPlayer(resource: String) -> AVAudioPlayer? {
        guard let player = makePlayer(resource: resource) else { return nil }
        player.numberOfLoops = -1
        return player
    }

    private func makeOneShotPlayer(resource: String) -> AVAudioPlayer? {
        makePlayer(resource: resource)
    }

    private func makePlayer(resource: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "mp3") else {
            return nil
        }
        guard let player = try? AVAudioPlayer(contentsOf: url) else { return nil }
        player.prepareToPlay()
        return player
    }

    private func playLoop(_ player: AVAudioPlayer?, volume: Float) {
        guard let player else { return }
        player.volume = volume
        player.currentTime = 0
        player.play()
    }

    private func playIceCrackOnce() {
        guard let frostCrackPlayer else { return }
        frostCrackPlayer.currentTime = 0
        frostCrackPlayer.play()
    }

    private func stopLoopingSounds() {
        lightWindPlayer?.stop()
        sonarPlayer?.stop()
        hardWindPlayer?.stop()
    }

    private func stopAll() {
        stopLoopingSounds()
        frostCrackPlayer?.stop()
    }
}
