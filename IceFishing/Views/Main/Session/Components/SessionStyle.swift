import SwiftUI

enum SessionStyle {
    static let cardFill = SurfaceStyle.panelFill
    static let cardStroke = SurfaceStyle.panelStroke
    static let fieldFill = Color(red: 0.07, green: 0.13, blue: 0.24)
    static let disabledButtonFill = Color(red: 0.13, green: 0.2, blue: 0.34)
    static let placeholderFill = Color(red: 0.14, green: 0.22, blue: 0.36)

    static var cardCornerRadius: CGFloat {
        ScreenSize.height * 0.016
    }

    static var fieldCornerRadius: CGFloat {
        ScreenSize.height * 0.014
    }

    static var cardBorderWidth: CGFloat {
        SurfaceStyle.panelBorderWidth
    }
}

enum SessionMetricStyle {
    static let fill = Color(red: 0.08, green: 0.14, blue: 0.25)
    static let stroke = Color(red: 0.38, green: 0.58, blue: 0.76)

    static var cornerRadius: CGFloat {
        ScreenSize.height * 0.018
    }

    static var borderWidth: CGFloat {
        max(1, ScreenSize.height * 0.0016)
    }

    static var horizontalPadding: CGFloat {
        ScreenSize.width * 0.05
    }

    static var verticalPadding: CGFloat {
        ScreenSize.height * 0.02
    }

    static var rowSpacing: CGFloat {
        ScreenSize.height * 0.016
    }

    static var labelFontSize: CGFloat {
        ScreenSize.height * 0.0145
    }

    static var valueFontSize: CGFloat {
        ScreenSize.height * 0.015
    }

    static var barHeight: CGFloat {
        ScreenSize.height * 0.01
    }
}

extension View {
    func sessionCardStyle(cornerRadius: CGFloat = SessionStyle.cardCornerRadius) -> some View {
        roundedPanel(
            cornerRadius: cornerRadius,
            fill: SessionStyle.cardFill,
            stroke: SessionStyle.cardStroke,
            lineWidth: SessionStyle.cardBorderWidth
        )
    }

    func sessionMetricPanelStyle() -> some View {
        padding(.horizontal, SessionMetricStyle.horizontalPadding)
            .padding(.vertical, SessionMetricStyle.verticalPadding)
            .roundedPanel(
                cornerRadius: SessionMetricStyle.cornerRadius,
                fill: SessionMetricStyle.fill,
                stroke: SessionMetricStyle.stroke,
                lineWidth: SessionMetricStyle.borderWidth
            )
    }
}
