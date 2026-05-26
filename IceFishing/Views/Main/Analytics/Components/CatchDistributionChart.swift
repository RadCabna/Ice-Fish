import SwiftUI

struct CatchDistributionChart: View {
    let values: CatchDistributionValues

    private let accent = Color(red: 0.35, green: 0.88, blue: 1.0)
    private let gridLevels: [Double] = [0.75, 1.5, 2.25, 3]
    private let axisLabels = ["Small Catches", "Big Multi", "Bonuses", "Dead Ice"]

    var body: some View {
        ZStack {
            radarCanvas
                .padding(.vertical, screenHeight * 0.034)
                .padding(.horizontal, screenWidth * 0.15)

            Text(axisLabels[0])
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            Text(axisLabels[2])
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            Text(axisLabels[3])
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            Text(axisLabels[1])
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
        .font(.system(size: screenHeight * 0.012))
        .foregroundStyle(Color.white.opacity(0.55))
        .frame(height: screenHeight * 0.28)
    }

    private var radarCanvas: some View {
        Canvas { context, size in
            guard size.width > 1, size.height > 1 else { return }

            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let maxRadius = min(size.width, size.height) * 0.36
            let dataValues = [
                values.smallCatches,
                values.bigMulti,
                values.bonuses,
                values.deadIce
            ]

            for level in gridLevels {
                let radius = maxRadius * CGFloat(level / 3)
                strokePolygon(context: context, center: center, radius: radius, color: Color.white.opacity(0.12))
            }

            for index in 0..<4 {
                let end = pointOnCircle(center: center, radius: maxRadius, axis: index)
                var axisLine = Path()
                axisLine.move(to: center)
                axisLine.addLine(to: end)
                context.stroke(axisLine, with: .color(Color.white.opacity(0.1)), lineWidth: 1)
            }

            var dataPath = Path()
            for index in 0..<4 {
                let radius = maxRadius * CGFloat(dataValues[index] / 3)
                let point = pointOnCircle(center: center, radius: radius, axis: index)
                if index == 0 {
                    dataPath.move(to: point)
                } else {
                    dataPath.addLine(to: point)
                }
            }
            dataPath.closeSubpath()
            context.fill(dataPath, with: .color(accent.opacity(0.28)))
            context.stroke(dataPath, with: .color(accent), lineWidth: 1.5)

            for index in 0..<4 {
                let radius = maxRadius * CGFloat(dataValues[index] / 3)
                let point = pointOnCircle(center: center, radius: radius, axis: index)
                var dot = Path()
                dot.addEllipse(in: CGRect(x: point.x - 3, y: point.y - 3, width: 6, height: 6))
                context.fill(dot, with: .color(accent))
            }
        }
    }

    private func strokePolygon(
        context: GraphicsContext,
        center: CGPoint,
        radius: CGFloat,
        color: Color
    ) {
        var path = Path()
        for index in 0..<4 {
            let point = pointOnCircle(center: center, radius: radius, axis: index)
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        context.stroke(path, with: .color(color), lineWidth: 1)
    }

    private func pointOnCircle(center: CGPoint, radius: CGFloat, axis: Int) -> CGPoint {
        let angle = -.pi / 2 + (Double(axis) * .pi / 2)
        return CGPoint(
            x: center.x + CGFloat(Darwin.cos(angle)) * radius,
            y: center.y + CGFloat(Darwin.sin(angle)) * radius
        )
    }
}

#Preview {
    CatchDistributionChart(
        values: CatchDistributionValues(
            smallCatches: 2.2,
            bigMulti: 1.5,
            bonuses: 1.8,
            deadIce: 0.9
        )
    )
    .padding()
    .mainBackground()
}
