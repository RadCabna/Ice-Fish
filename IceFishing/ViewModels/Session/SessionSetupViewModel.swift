import Foundation

@MainActor
final class SessionSetupViewModel: ObservableObject {
    @Published var stopLossText = ""
    @Published var takeProfitText = ""
    @Published var timerMinutes: Double = SessionSetupViewModel.clampedDuration(
        SettingsViewModel.storedDefaultSessionMinutes()
    )
    @Published var dotPulseToken = 0

    private var suppressSideEffects = false

    let timerRange: ClosedRange<Double> = 10...60
    let timerStep: Double = 5

    var canStartSession: Bool {
        parsedStopLoss != nil && parsedTakeProfit != nil
    }

    var timerLabel: String {
        "\(Int(timerMinutes)) min"
    }

    func triggerDotPulse() {
        guard !suppressSideEffects else { return }
        dotPulseToken += 1
    }

    func setDefaultDuration(_ minutes: Int) {
        timerMinutes = Self.clampedDuration(Double(minutes))
    }

    func resetForm() {
        suppressSideEffects = true
        stopLossText = ""
        takeProfitText = ""
        timerMinutes = Self.clampedDuration(SettingsViewModel.storedDefaultSessionMinutes())
        dotPulseToken = 0
        suppressSideEffects = false
    }

    private static func clampedDuration(_ minutes: Double) -> Double {
        let range: ClosedRange<Double> = 10...60
        let step: Double = 5
        guard minutes.isFinite else { return range.lowerBound }

        let bounded = min(max(minutes, range.lowerBound), range.upperBound)
        let steps = round((bounded - range.lowerBound) / step)
        return min(range.upperBound, range.lowerBound + steps * step)
    }

    func makeConfig() -> SessionConfig? {
        guard let stopLoss = parsedStopLoss,
              let takeProfit = parsedTakeProfit else { return nil }
        return SessionConfig(
            stopLoss: stopLoss,
            takeProfit: takeProfit,
            timerMinutes: Int(timerMinutes)
        )
    }

    private var parsedStopLoss: Double? {
        parseAmount(stopLossText)
    }

    private var parsedTakeProfit: Double? {
        parseAmount(takeProfitText)
    }

    private func parseAmount(_ text: String) -> Double? {
        let sanitized = text
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Double(sanitized), value > 0 else { return nil }
        return value
    }
}
