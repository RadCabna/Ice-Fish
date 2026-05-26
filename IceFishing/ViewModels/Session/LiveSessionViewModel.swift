import Foundation

@MainActor
final class LiveSessionViewModel: ObservableObject {
    @Published private(set) var elapsedSeconds: Int = 0
    @Published private(set) var balance: Double = 0
    @Published private(set) var frostPercent: Double = 0
    @Published private(set) var bigCatchCount: Int = 0
    @Published private(set) var bonusCount: Int = 0
    @Published private(set) var smallCatchCount: Int = 0
    @Published private(set) var frostWarningMessage: String?

    let config: SessionConfig

    private var timerTask: Task<Void, Never>?

    var isSessionBlocked: Bool {
        frostPercent >= 100
    }

    var canLogCatch: Bool {
        !isSessionBlocked
    }

    var formattedTime: String {
        let minutes = elapsedSeconds / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var formattedBalance: String {
        if balance >= 0 {
            return String(format: "$%.0f", balance)
        }
        return String(format: "$%.0f", balance)
    }

    var frostPercentLabel: String {
        "\(Int(frostPercent.rounded()))%"
    }

    var profitProgress: Double {
        guard balance >= 0, config.takeProfit > 0 else { return 0 }
        return min(1, balance / config.takeProfit)
    }

    var lossProgress: Double {
        guard balance < 0, config.stopLoss > 0 else { return 0 }
        return min(1, abs(balance) / config.stopLoss)
    }

    var isProfitDirection: Bool {
        balance >= 0
    }

    var onIceImageName: String {
        guard isProfitDirection else { return "onIce_1" }
        switch profitProgress {
        case ..<0.34:
            return "onIce_1"
        case ..<0.67:
            return "onIce_2"
        default:
            return "onIce_3"
        }
    }

    var frostFrameOpacity: Double {
        min(1, max(0, frostPercent / 100))
    }

    init(config: SessionConfig) {
        self.config = config
    }

    func start() {
        SessionAudioManager.shared.sessionDidStart()
        timerTask?.cancel()
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                tick()
            }
        }
    }

    func stop() {
        stopTimer()
        SessionAudioManager.shared.sessionDidEnd()
    }

    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    func logCatch(_ type: CatchEventType) {
        guard canLogCatch else { return }
        balance += type.placeholderDelta
        switch type {
        case .smallFish:
            smallCatchCount += 1
        case .bigFish:
            bigCatchCount += 1
        case .bonus:
            bonusCount += 1
        case .deadIce:
            break
        }
        updateFrost()
    }

    func applyPreviewIceLock(elapsedSeconds: Int, balance: Double) {
        self.elapsedSeconds = elapsedSeconds
        self.balance = balance
        frostPercent = 100
        frostWarningMessage = nil
        stopTimer()
        SessionAudioManager.shared.updateFrostLevel(100)
    }

    func makeSummary() -> SessionSummary {
        SessionSummary(
            balance: balance,
            durationSeconds: max(1, elapsedSeconds),
            frostPeakPercent: Int(frostPercent.rounded()),
            bigCatchCount: bigCatchCount,
            bonusCount: bonusCount,
            smallCatchCount: smallCatchCount,
            endedAt: Date()
        )
    }

    private func tick() {
        elapsedSeconds += 1
        updateFrost()
    }

    private func updateFrost() {
        let totalSeconds = max(1, config.timerMinutes * 60)
        let timePercent = min(100, (Double(elapsedSeconds) / Double(totalSeconds)) * 100)
        let lossPercent: Double
        if balance < 0, config.stopLoss > 0 {
            lossPercent = min(100, (abs(balance) / config.stopLoss) * 100)
        } else {
            lossPercent = 0
        }
        let previousFrost = frostPercent
        frostPercent = max(timePercent, lossPercent)
        SessionAudioManager.shared.updateFrostLevel(frostPercent)
        if frostPercent >= 100, previousFrost < 100 {
            stopTimer()
        }
        updateFrostMessage()
    }

    private func updateFrostMessage() {
        switch frostPercent {
        case 71..<100:
            frostWarningMessage = "Frost is tightening. Your limit is almost reached."
        case 100...:
            frostWarningMessage = nil
        default:
            frostWarningMessage = nil
        }
    }
}
