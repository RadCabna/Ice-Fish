import Foundation

@MainActor
final class SessionSetupViewModel: ObservableObject {
    @Published var stopLossText = ""
    @Published var takeProfitText = ""
    @Published var timerMinutes: Double = SettingsViewModel.storedDefaultSessionMinutes()
    @Published var dotPulseToken = 0

    let timerRange: ClosedRange<Double> = 10...60
    let timerStep: Double = 5

    var canStartSession: Bool {
        parsedStopLoss != nil && parsedTakeProfit != nil
    }

    var timerLabel: String {
        "\(Int(timerMinutes)) min"
    }

    func triggerDotPulse() {
        dotPulseToken += 1
    }

    func resetForm() {
        stopLossText = ""
        takeProfitText = ""
        timerMinutes = SettingsViewModel.storedDefaultSessionMinutes()
        dotPulseToken = 0
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
