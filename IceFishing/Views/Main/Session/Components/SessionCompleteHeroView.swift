import SwiftUI
import UIKit

struct SessionCompleteHeroView: View {
    let isProfitable: Bool

    private var imageName: String {
        isProfitable ? "succesFinish" : "onIce_1"
    }

    private var heroHeight: CGFloat {
        screenWidth / Self.referenceAspectRatio
    }

    private static let referenceAspectRatio: CGFloat = {
        let profitableImage = UIImage(named: "succesFinish")
        let lossImage = UIImage(named: "onIce_1")
        let image = profitableImage ?? lossImage
        guard let image, image.size.height > 0 else {
            return 1.28
        }
        return image.size.width / image.size.height
    }()

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: screenWidth * 0.9, height: heroHeight)
            .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.018, style: .continuous))
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 16) {
        SessionCompleteHeroView(isProfitable: true)
        SessionCompleteHeroView(isProfitable: false)
    }
    .mainBackground()
    .environmentObject(SettingsViewModel())
}
