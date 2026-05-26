import SwiftUI

struct EchoSounderView: View {
    let blips: [SonarBlip]

    private let accent = Color(red: 0.35, green: 0.88, blue: 1.0)
    private let ringCount = 4
    private let sweepAngle: Double = -58

    private var sonarHeight: CGFloat {
        screenHeight * 0.22
    }

    private var maxBlipRadius: CGFloat {
        let ringWidth = stadiumWidth(progress: 0.9)
        let ringHeight = stadiumHeight(progress: 0.9)
        return max(1, min(ringWidth, ringHeight) * 0.42)
    }

    var body: some View {
        ZStack {
            ForEach(1...ringCount, id: \.self) { ring in
                stadiumRing(progress: CGFloat(ring) / CGFloat(ringCount) * 0.9)
            }

            stadiumFrame(progress: 1, cornerScale: 0.38)

            sweepLine

            ForEach(blips) { blip in
                catchBlip(blip)
            }

            Circle()
                .fill(accent)
                .frame(width: screenHeight * 0.014, height: screenHeight * 0.014)
                .shadow(color: accent.opacity(0.95), radius: 6)
                .shadow(color: accent.opacity(0.45), radius: 14)
                .overlay {
                    Circle()
                        .stroke(Color.white.opacity(0.75), lineWidth: 1)
                }
        }
        .frame(height: sonarHeight)
        .frame(maxWidth: .infinity)
    }

    private func catchBlip(_ blip: SonarBlip) -> some View {
        let radius = maxBlipRadius * blip.distanceFromCenter
        let xOffset = CGFloat(Darwin.cos(blip.angle)) * radius
        let yOffset = CGFloat(Darwin.sin(blip.angle)) * radius
        let intensity = max(0, min(1, 1 - blip.distanceFromCenter))
        let diameter = max(4, 4 + intensity * 5)

        return Circle()
            .fill(accent.opacity(0.35 + Double(intensity) * 0.5))
            .frame(width: diameter, height: diameter)
            .offset(x: xOffset, y: yOffset)
    }

    private func stadiumFrame(progress: CGFloat, cornerScale: CGFloat) -> some View {
        let width = stadiumWidth(progress: progress)
        let height = stadiumHeight(progress: progress)
        let cornerRadius = max(0, min(height * cornerScale, width / 2))

        return RoundedRectangle(
            cornerRadius: cornerRadius,
            style: .continuous
        )
        .stroke(accent.opacity(0.22), lineWidth: 1)
        .frame(width: width, height: height)
    }

    private func stadiumRing(progress: CGFloat) -> some View {
        let width = stadiumWidth(progress: progress)
        let height = stadiumHeight(progress: progress)
        let cornerRadius = max(0, min(height / 2, width / 2))

        return RoundedRectangle(
            cornerRadius: cornerRadius,
            style: .continuous
        )
        .stroke(Color.white.opacity(0.14), lineWidth: 1)
        .frame(width: width, height: height)
    }

    private func stadiumWidth(progress: CGFloat) -> CGFloat {
        max(1, screenWidth * 0.8 * progress)
    }

    private func stadiumHeight(progress: CGFloat) -> CGFloat {
        max(1, screenHeight * 0.36 * progress * 0.58)
    }

    private var sweepLine: some View {
        Rectangle()
            .fill(accent.opacity(0.75))
            .frame(width: 1.5, height: max(1, screenHeight * 0.11))
            .rotationEffect(.degrees(sweepAngle))
    }
}

#Preview {
    AnalyticsPanel(title: "Echo Sounder") {
        EchoSounderView(blips: [])
    }
    .padding()
    .mainBackground()
    .environmentObject(SettingsViewModel())
}
