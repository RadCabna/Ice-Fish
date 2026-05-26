import SwiftUI
import UIKit

enum ScreenSize {
    static var height: CGFloat {
        UIScreen.main.bounds.height
    }

    static var width: CGFloat {
        UIScreen.main.bounds.width
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
