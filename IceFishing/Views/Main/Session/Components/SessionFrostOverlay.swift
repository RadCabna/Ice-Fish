import SwiftUI

struct SessionFrostOverlay: View {
    let frostPercent: Double

    private var overlayOpacity: Double {
        min(0.92, frostPercent / 100 * 0.9)
    }

    private var cornerIntensity: Double {
        min(1, max(0, (frostPercent - 40) / 60))
    }

    var body: some View {
        ZStack {
            if frostPercent > 40 {
                RadialGradient(
                    colors: [
                        Color.white.opacity(0.05),
                        Color.white.opacity(0.25 * cornerIntensity)
                    ],
                    center: .center,
                    startRadius: screenWidth * 0.1,
                    endRadius: screenWidth * 0.75
                )
            }

            if frostPercent > 70 {
                Color.white.opacity(0.08 * cornerIntensity)
            }

            if frostPercent >= 100 {
                Color.white.opacity(0.75)
            }
        }
        .opacity(overlayOpacity)
        .allowsHitTesting(false)
        .animation(.easeInOut(duration: 0.35), value: frostPercent)
    }
}

#Preview {
    ZStack {
        MainBackground()
        SessionFrostOverlay(frostPercent: 85)
    }
}
