import Foundation

struct SessionSummary: Equatable, Hashable, Codable {
    let balance: Double
    let durationSeconds: Int
    let frostPeakPercent: Int
    let bigCatchCount: Int
    let bonusCount: Int
    let smallCatchCount: Int
    let endedAt: Date

    var isProfitable: Bool {
        balance > 0
    }

    var totalCatchCount: Int {
        bigCatchCount + bonusCount + smallCatchCount
    }

    var formattedBalance: String {
        if balance >= 0 {
            return String(format: "+$%.2f", balance)
        }
        return String(format: "-$%.2f", abs(balance))
    }
}
