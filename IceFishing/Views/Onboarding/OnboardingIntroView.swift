import SwiftUI

struct OnboardingIntroView: View {
    @State private var orbScale: CGFloat = 0.9

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: screenHeight * 0.12)

            glowingOrb
                .frame(height: screenHeight * 0.38)

            VStack(spacing: screenHeight * 0.014) {
                Text("Keep your mind cold.")
                    .font(.system(size: screenHeight * 0.034, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text("And your catch — profitable.")
                    .font(.system(size: screenHeight * 0.02, weight: .regular))
                    .foregroundStyle(.white.opacity(0.88))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, screenWidth * 0.082)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            startOrbPulse()
        }
    }

    private var glowingOrb: some View {
        ZStack {
            ForEach(0..<starBasePositions.count, id: \.self) { index in
                let position = starBasePositions[index]
                FloatingStarView(
                    baseX: position.x,
                    baseY: position.y,
                    seed: index
                )
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.95),
                            Color.white.opacity(0.45),
                            Color(red: 0.55, green: 0.78, blue: 1.0).opacity(0.25),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: screenWidth * 0.32 * orbScale
                    )
                )
                .frame(
                    width: screenWidth * 0.52 * orbScale,
                    height: screenWidth * 0.52 * orbScale
                )
                .blur(radius: screenHeight * 0.021)
        }
    }

    private var starBasePositions: [CGPoint] {
        [
            CGPoint(x: -screenWidth * 0.28, y: -screenHeight * 0.06),
            CGPoint(x: screenWidth * 0.22, y: -screenHeight * 0.1),
            CGPoint(x: screenWidth * 0.3, y: screenHeight * 0.04),
            CGPoint(x: -screenWidth * 0.18, y: screenHeight * 0.08)
        ]
    }

    private func startOrbPulse() {
        orbScale = 0.88
        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
            orbScale = 1.14
        }
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true, appliesPadding: false) {
        OnboardingIntroView()
    }
}
