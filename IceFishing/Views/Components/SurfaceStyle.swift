import SwiftUI

enum SurfaceStyle {
    static let panelFill = Color(red: 0.11, green: 0.19, blue: 0.32)
    static let panelStroke = Color(red: 0.28, green: 0.42, blue: 0.58)
    static let barFill = Color(red: 0.05, green: 0.09, blue: 0.2)
    static let tabHighlightFill = Color(red: 0.14, green: 0.38, blue: 0.52)
    static let subtleFill = Color.white.opacity(0.08)
    static let fieldFill = Color.white.opacity(0.06)

    static var panelBorderWidth: CGFloat {
        ScreenSize.height * 0.0015
    }
}

extension View {
    func shapePanel<S: InsettableShape>(
        _ shape: S,
        fill: some ShapeStyle,
        stroke: Color? = nil,
        lineWidth: CGFloat = 0
    ) -> some View {
        background(shape.fill(fill))
            .overlay {
                if let stroke, lineWidth > 0 {
                    shape.strokeBorder(stroke, lineWidth: lineWidth)
                }
            }
    }

    func roundedPanel(
        cornerRadius: CGFloat,
        fill: some ShapeStyle,
        stroke: Color? = nil,
        lineWidth: CGFloat = 0
    ) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        return frame(maxWidth: .infinity, alignment: .leading)
            .shapePanel(shape, fill: fill, stroke: stroke, lineWidth: lineWidth)
    }
}
