import SwiftUI

struct FloatingStarView: View {
    let baseX: CGFloat
    let baseY: CGFloat
    let seed: Int

    @State private var driftX: CGFloat = 0
    @State private var driftY: CGFloat = 0

    private var duration: Double {
        8 + Double(seed % 5) * 1.2
    }

    private var targetDriftX: CGFloat {
        screenWidth * [-0.06, 0.08, -0.05, 0.065, 0.075][seed % 5]
    }

    private var targetDriftY: CGFloat {
        screenHeight * [-0.021, 0.026, -0.033, 0.019, -0.028][seed % 5]
    }

    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.7))
            .frame(
                width: screenHeight * 0.005,
                height: screenHeight * 0.005
            )
            .offset(x: baseX + driftX, y: baseY + driftY)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    driftX = targetDriftX
                    driftY = targetDriftY
                }
            }
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true) {
        ZStack {
            FloatingStarView(
                baseX: -ScreenSize.width * 0.1,
                baseY: -ScreenSize.height * 0.024,
                seed: 0
            )
            FloatingStarView(
                baseX: ScreenSize.width * 0.12,
                baseY: -ScreenSize.height * 0.036,
                seed: 1
            )
        }
    }
}
