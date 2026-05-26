import SwiftUI
import UIKit

enum ScreenSize {
    private static let fallbackWidth: CGFloat = 390
    private static let fallbackHeight: CGFloat = 844

    static var height: CGFloat {
        sanitized(currentBounds.height, fallback: fallbackHeight)
    }

    static var width: CGFloat {
        sanitized(currentBounds.width, fallback: fallbackWidth)
    }

    private static var currentBounds: CGRect {
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap(\.windows)
            .first(where: \.isKeyWindow) {
            let bounds = window.bounds
            if bounds.width > 0, bounds.height > 0 {
                return bounds
            }
        }

        let bounds = UIScreen.main.bounds
        if bounds.width > 0, bounds.height > 0 {
            return bounds
        }

        return CGRect(x: 0, y: 0, width: fallbackWidth, height: fallbackHeight)
    }

    private static func sanitized(_ value: CGFloat, fallback: CGFloat) -> CGFloat {
        guard value.isFinite, value > 0 else { return fallback }
        return value
    }
}

extension View {
    var screenWidth: CGFloat {
        ScreenSize.width
    }

    var screenHeight: CGFloat {
        ScreenSize.height
    }
}

extension CGSize {
    var sanitized: CGSize {
        CGSize(
            width: max(1, width.isFinite ? width : ScreenSize.width),
            height: max(1, height.isFinite ? height : ScreenSize.height)
        )
    }
}
