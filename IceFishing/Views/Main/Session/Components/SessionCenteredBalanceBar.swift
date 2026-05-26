import SwiftUI

struct SessionCenteredBalanceBar: View {
    let profitProgress: Double
    let lossProgress: Double

    private let profitColors = [
        Color(red: 0.2, green: 0.78, blue: 0.42),
        Color(red: 0.35, green: 0.92, blue: 0.55)
    ]

    private let lossColors = [
        Color(red: 0.92, green: 0.22, blue: 0.2),
        Color(red: 1.0, green: 0.38, blue: 0.3)
    ]

    var body: some View {
        GeometryReader { geometry in
            let halfWidth = geometry.size.width / 2
            let profit = min(1, max(0, profitProgress))
            let loss = min(1, max(0, lossProgress))

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))

                if loss > 0 {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: lossColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: halfWidth * loss)
                        .offset(x: halfWidth - halfWidth * loss)
                }

                if profit > 0 {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: profitColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: halfWidth * profit)
                        .offset(x: halfWidth)
                }
            }
        }
        .frame(height: SessionMetricStyle.barHeight)
        .animation(.easeInOut(duration: 0.3), value: profitProgress)
        .animation(.easeInOut(duration: 0.3), value: lossProgress)
    }
}

#Preview {
    VStack(spacing: 20) {
        SessionCenteredBalanceBar(profitProgress: 0.45, lossProgress: 0)
        SessionCenteredBalanceBar(profitProgress: 0, lossProgress: 0.6)
    }
    .padding()
    .sessionCardStyle()
    .padding()
    .mainBackground()
}
