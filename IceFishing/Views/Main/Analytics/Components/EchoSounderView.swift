import SwiftUI

struct EchoSounderView: View {
    let blips: [SonarBlip]

    private let accent = Color(red: 0.35, green: 0.88, blue: 1.0)
    private let ringCount = 4
    private let sweepPeriod: TimeInterval = 3.4
    private let beamWidth: Double = 0.24
    private let outerCornerScale: CGFloat = 0.38

    private var sonarHeight: CGFloat {
        screenHeight * 0.22
    }

    private var outerWidth: CGFloat {
        stadiumWidth(progress: 1)
    }

    private var outerHeight: CGFloat {
        stadiumHeight(progress: 1)
    }

    private var maxBlipRadius: CGFloat {
        max(1, min(outerWidth, outerHeight) * 0.42)
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 60, paused: false)) { timeline in
            let angle = sweepAngle(at: timeline.date)

            ZStack {
                ForEach(0..<max(0, ringCount), id: \.self) { index in
                    let ring = index + 1
                    stadiumRing(progress: CGFloat(ring) / CGFloat(ringCount) * 0.9)
                }

                stadiumFrame(progress: 1, cornerScale: outerCornerScale)

                ZStack {
                    SonarSweepCanvas(
                        angle: angle,
                        accent: accent,
                        stadiumWidth: outerWidth,
                        stadiumHeight: outerHeight,
                        cornerScale: outerCornerScale
                    )

                    ForEach(blips) { blip in
                        catchBlip(blip, scanAngle: angle)
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
                .frame(width: outerWidth, height: outerHeight)
            }
            .frame(height: sonarHeight)
            .frame(maxWidth: .infinity)
        }
    }

    private func catchBlip(_ blip: SonarBlip, scanAngle: Double) -> some View {
        let radius = maxBlipRadius * blip.distanceFromCenter
        let xOffset = CGFloat(Darwin.cos(blip.angle)) * radius
        let yOffset = CGFloat(Darwin.sin(blip.angle)) * radius
        let baseIntensity = max(0, min(1, 1 - blip.distanceFromCenter))
        let activation = scanActivation(for: blip.angle, scanAngle: scanAngle)

        let offOpacity = 0.05 + Double(baseIntensity) * 0.12
        let onOpacity = 0.18 + Double(baseIntensity) * 0.55
        let opacity = offOpacity + (onOpacity - offOpacity) * activation

        let diameter = max(4, 4 + baseIntensity * 3.2 + activation * 7.0)
        let scale = 1 + activation * 0.55

        return Circle()
            .fill(accent.opacity(opacity))
            .frame(width: diameter, height: diameter)
            .scaleEffect(scale)
            .shadow(color: accent.opacity(activation * 0.9), radius: activation > 0.04 ? 9 : 0)
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

    private func sweepAngle(at date: Date) -> Double {
        let phase = (date.timeIntervalSinceReferenceDate / sweepPeriod)
            .truncatingRemainder(dividingBy: 1)
        return phase * 2 * .pi - .pi / 2
    }

    private func scanActivation(for blipAngle: Double, scanAngle: Double) -> Double {
        let delta = angularDistance(blipAngle, scanAngle)
        if delta >= beamWidth { return 0 }
        var x = delta / beamWidth
        x = max(0, min(1, x))
        let v = 1 - x
        return v * v * (3 - 2 * v)
    }

    private func angularDistance(_ lhs: Double, _ rhs: Double) -> Double {
        let diff = abs(lhs - rhs).truncatingRemainder(dividingBy: 2 * .pi)
        return min(diff, 2 * .pi - diff)
    }
}

// MARK: - Rotating sweep (Canvas)

private struct SonarSweepCanvas: View {
    let angle: Double
    let accent: Color
    let stadiumWidth: CGFloat
    let stadiumHeight: CGFloat
    let cornerScale: CGFloat

    private var clipShape: SonarStadiumShape {
        SonarStadiumShape(
            width: stadiumWidth,
            height: stadiumHeight,
            cornerScale: cornerScale
        )
    }

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let maxRadius = maxRadiusToBoundary(from: center, in: size)

            // Trailing glow (behind the main beam).
            let trailSteps = 10
            for step in 1...trailSteps {
                let trailAngle = angle - Double(step) * 0.045
                let fade = 1 - Double(step) / Double(trailSteps + 1)
                drawBeam(
                    context: &context,
                    center: center,
                    angle: trailAngle,
                    radius: maxRadius,
                    opacity: fade * 0.22,
                    lineWidth: 1.2
                )
            }

            drawBeam(
                context: &context,
                center: center,
                angle: angle,
                radius: maxRadius,
                opacity: 0.95,
                lineWidth: 1.8
            )
        }
        .frame(width: stadiumWidth, height: stadiumHeight)
        .clipShape(clipShape)
    }

    private func drawBeam(
        context: inout GraphicsContext,
        center: CGPoint,
        angle: Double,
        radius: CGFloat,
        opacity: Double,
        lineWidth: CGFloat
    ) {
        let end = CGPoint(
            x: center.x + CGFloat(Darwin.cos(angle)) * radius,
            y: center.y + CGFloat(Darwin.sin(angle)) * radius
        )

        var path = Path()
        path.move(to: center)
        path.addLine(to: end)

        context.stroke(
            path,
            with: .color(accent.opacity(opacity)),
            style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
        )
    }

    /// Ray length from center to stadium edge along `angle` (stay inside zone).
    private func maxRadiusToBoundary(from center: CGPoint, in size: CGSize) -> CGFloat {
        let halfW = size.width / 2
        let halfH = size.height / 2
        let cornerRadius = max(0, min(size.height * cornerScale, size.width / 2))
        let inset = cornerRadius * 0.35

        let cosA = abs(CGFloat(Darwin.cos(angle)))
        let sinA = abs(CGFloat(Darwin.sin(angle)))

        guard cosA > 0.0001, sinA > 0.0001 else {
            return min(halfW, halfH) - inset
        }

        let radiusX = (halfW - inset) / cosA
        let radiusY = (halfH - inset) / sinA
        return max(1, min(radiusX, radiusY))
    }
}

private struct SonarStadiumShape: Shape {
    let width: CGFloat
    let height: CGFloat
    let cornerScale: CGFloat

    func path(in rect: CGRect) -> Path {
        let cornerRadius = max(0, min(height * cornerScale, width / 2))
        return RoundedRectangle(
            cornerRadius: cornerRadius,
            style: .continuous
        ).path(in: CGRect(
            x: rect.midX - width / 2,
            y: rect.midY - height / 2,
            width: width,
            height: height
        ))
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
