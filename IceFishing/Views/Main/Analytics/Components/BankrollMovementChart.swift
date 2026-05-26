import SwiftUI

struct BankrollMovementChart: View {
    let points: [BankrollPoint]
    let yMax: Double

    @State private var selectedPointID: Int?

    private let accent = Color(red: 0.35, green: 0.88, blue: 1.0)

    private var selectedPoint: BankrollPoint? {
        guard let selectedPointID else { return nil }
        return points.first { $0.id == selectedPointID }
    }

    private var safeYMax: Double {
        guard yMax.isFinite, yMax > 0 else { return 100 }
        return yMax
    }

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            if let selectedPoint {
                tooltip(for: selectedPoint)
            }

            GeometryReader { geometry in
                chartCanvas(size: geometry.size)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                selectPoint(at: value.location, in: geometry.size)
                            }
                    )
                    .onTapGesture { location in
                        selectPoint(at: location, in: geometry.size)
                    }
            }
            .frame(height: screenHeight * 0.2)

            xAxisLabels
        }
        .onAppear {
            selectedPointID = points.last?.id
        }
    }

    private var xAxisLabels: some View {
        HStack(spacing: 0) {
            ForEach(points) { point in
                Text(point.label)
                    .font(.system(size: screenHeight * 0.011))
                    .foregroundStyle(Color.white.opacity(0.45))
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, screenWidth * 0.08)
    }

    private func chartCanvas(size: CGSize) -> some View {
        Canvas { context, canvasSize in
            guard canvasSize.width > 1, canvasSize.height > 1, !points.isEmpty else { return }

            let plotRect = plotArea(in: canvasSize)
            drawGrid(context: context, plotRect: plotRect)
            drawLine(context: context, plotRect: plotRect)

            if let selectedPointID,
               let point = points.first(where: { $0.id == selectedPointID }) {
                drawSelection(context: context, plotRect: plotRect, point: point)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.01, style: .continuous)
                .fill(Color.white.opacity(0.03))
        )
    }

    private func drawGrid(context: GraphicsContext, plotRect: CGRect) {
        let yStride = max(1, safeYMax / 4)

        for step in 0...4 {
            let value = Double(step) * yStride
            let y = yPosition(for: value, in: plotRect)
            var line = Path()
            line.move(to: CGPoint(x: plotRect.minX, y: y))
            line.addLine(to: CGPoint(x: plotRect.maxX, y: y))
            context.stroke(line, with: .color(Color.white.opacity(0.08)), lineWidth: 0.5)

            let label = Text("\(Int(value))")
                .font(.system(size: screenHeight * 0.011))
                .foregroundColor(Color.white.opacity(0.45))
            context.draw(
                label,
                at: CGPoint(x: plotRect.minX - 4, y: y),
                anchor: .trailing
            )
        }
    }

    private func drawLine(context: GraphicsContext, plotRect: CGRect) {
        guard let first = points.first else { return }

        var line = Path()
        line.move(to: coordinates(for: first, in: plotRect))

        for point in points.dropFirst() {
            line.addLine(to: coordinates(for: point, in: plotRect))
        }

        if points.count > 1 {
            context.stroke(
                line,
                with: .color(accent),
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
        }

        for point in points {
            let location = coordinates(for: point, in: plotRect)
            let isSelected = point.id == selectedPointID
            let radius: CGFloat = isSelected ? 5 : 3.5
            var dot = Path()
            dot.addEllipse(in: CGRect(
                x: location.x - radius,
                y: location.y - radius,
                width: radius * 2,
                height: radius * 2
            ))
            context.fill(dot, with: .color(accent))
        }
    }

    private func drawSelection(context: GraphicsContext, plotRect: CGRect, point: BankrollPoint) {
        let location = coordinates(for: point, in: plotRect)
        var guide = Path()
        guide.move(to: CGPoint(x: location.x, y: plotRect.minY))
        guide.addLine(to: CGPoint(x: location.x, y: plotRect.maxY))
        context.stroke(
            guide,
            with: .color(Color.white.opacity(0.85)),
            style: StrokeStyle(lineWidth: 1, dash: [4, 4])
        )
    }

    private func plotArea(in size: CGSize) -> CGRect {
        let leftInset = size.width * 0.14
        let bottomInset = size.height * 0.08
        return CGRect(
            x: leftInset,
            y: size.height * 0.06,
            width: max(1, size.width - leftInset - size.width * 0.04),
            height: max(1, size.height - size.height * 0.06 - bottomInset)
        )
    }

    private func coordinates(for point: BankrollPoint, in plotRect: CGRect) -> CGPoint {
        CGPoint(
            x: xPosition(for: point, in: plotRect),
            y: yPosition(for: point.balance, in: plotRect)
        )
    }

    private func xPosition(for point: BankrollPoint, in plotRect: CGRect) -> CGFloat {
        guard points.count > 1 else {
            return plotRect.midX
        }

        guard let index = points.firstIndex(where: { $0.id == point.id }) else {
            return plotRect.midX
        }

        let progress = CGFloat(index) / CGFloat(points.count - 1)
        return plotRect.minX + plotRect.width * progress
    }

    private func yPosition(for balance: Double, in plotRect: CGRect) -> CGFloat {
        let clamped = min(max(balance, 0), safeYMax)
        let progress = clamped / safeYMax
        return plotRect.maxY - plotRect.height * CGFloat(progress)
    }

    private func selectPoint(at location: CGPoint, in size: CGSize) {
        guard !points.isEmpty else { return }

        let plotRect = plotArea(in: size)
        var nearestID = points[0].id
        var nearestDistance = CGFloat.greatestFiniteMagnitude

        for point in points {
            let x = xPosition(for: point, in: plotRect)
            let distance = abs(x - location.x)
            if distance < nearestDistance {
                nearestDistance = distance
                nearestID = point.id
            }
        }

        selectedPointID = nearestID
    }

    private func tooltip(for point: BankrollPoint) -> some View {
        HStack(spacing: screenWidth * 0.02) {
            Text(point.label)
                .foregroundStyle(.white)
            Text("balance:\(Int(point.balance))")
                .foregroundStyle(accent)
        }
        .font(.system(size: screenHeight * 0.013, weight: .medium))
        .padding(.horizontal, screenWidth * 0.035)
        .padding(.vertical, screenHeight * 0.008)
        .background(
            RoundedRectangle(cornerRadius: screenHeight * 0.01, style: .continuous)
                .fill(Color(red: 0.08, green: 0.14, blue: 0.24))
        )
        .overlay(
            RoundedRectangle(cornerRadius: screenHeight * 0.01, style: .continuous)
                .stroke(accent.opacity(0.7), lineWidth: screenHeight * 0.0012)
        )
    }
}

#Preview {
    BankrollMovementChart(
        points: [
            BankrollPoint(id: 0, label: "Day 1", balance: 40),
            BankrollPoint(id: 1, label: "Day 2", balance: 90),
            BankrollPoint(id: 2, label: "Day 3", balance: 55)
        ],
        yMax: 100
    )
    .padding()
    .mainBackground()
}
