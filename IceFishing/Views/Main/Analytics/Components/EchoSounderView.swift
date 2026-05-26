import SwiftUI

struct EchoSounderView: View {
    let blipStrengths: [Double]

    private let accent = Color(red: 0.35, green: 0.88, blue: 1.0)
    private let ringCount = 4
    private let sweepAngle: Double = -58

    private let blipPositions: [(x: CGFloat, y: CGFloat, index: Int)] = [
        (0.28, 0.5, 0),
        (0.72, 0.48, 1),
        (0.55, 0.32, 2),
        (0.42, 0.66, 3),
        (0.38, 0.42, 5)
    ]

    var body: some View {
        ZStack {
            ForEach(1...ringCount, id: \.self) { ring in
                stadiumRing(progress: CGFloat(ring) / CGFloat(ringCount) * 0.9)
            }

            stadiumFrame(progress: 1, cornerScale: 0.38)

            sweepLine

            ForEach(blipPositions, id: \.index) { position in
                blip(at: position)
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
        .frame(height: screenHeight * 0.22)
        .frame(maxWidth: .infinity)
    }

    private func stadiumFrame(progress: CGFloat, cornerScale: CGFloat) -> some View {
        let width = stadiumWidth(progress: progress)
        let height = stadiumHeight(progress: progress)

        return RoundedRectangle(
            cornerRadius: height * cornerScale,
            style: .continuous
        )
        .stroke(accent.opacity(0.22), lineWidth: 1)
        .frame(width: width, height: height)
    }

    private func stadiumRing(progress: CGFloat) -> some View {
        let width = stadiumWidth(progress: progress)
        let height = stadiumHeight(progress: progress)

        return RoundedRectangle(
            cornerRadius: height / 2,
            style: .continuous
        )
        .stroke(Color.white.opacity(0.14), lineWidth: 1)
        .frame(width: width, height: height)
    }

    private func stadiumWidth(progress: CGFloat) -> CGFloat {
        screenWidth * 0.8 * progress
    }

    private func stadiumHeight(progress: CGFloat) -> CGFloat {
        screenHeight * 0.36 * progress * 0.58
    }

    private var sweepLine: some View {
        Rectangle()
            .fill(accent.opacity(0.75))
            .frame(width: 1.5, height: screenHeight * 0.11)
            .rotationEffect(.degrees(sweepAngle))
    }

    @ViewBuilder
    private func blip(at position: (x: CGFloat, y: CGFloat, index: Int)) -> some View {
        let strength = position.index < blipStrengths.count
            ? blipStrengths[position.index]
            : 0.5
        let diameter = CGFloat(5 + strength * 4)

        Circle()
            .fill(accent.opacity(0.35 + strength * 0.45))
            .frame(width: diameter, height: diameter)
            .offset(
                x: (position.x - 0.5) * screenWidth * 0.62,
                y: (position.y - 0.5) * screenHeight * 0.12
            )
    }
}

#Preview {
    AnalyticsPanel(title: "Echo Sounder") {
        EchoSounderView(blipStrengths: [0.4, 0.7, 0.5, 0.9])
    }
    .padding()
    .mainBackground()
}
