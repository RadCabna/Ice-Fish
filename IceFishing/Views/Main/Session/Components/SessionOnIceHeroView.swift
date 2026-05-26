import SwiftUI
import UIKit

struct SessionOnIceHeroView: View {
    let onIceImageName: String
    let frostFrameOpacity: Double

    private var heroHeight: CGFloat {
        screenWidth / Self.referenceAspectRatio
    }

    private static let referenceAspectRatio: CGFloat = {
        guard let image = UIImage(named: "onIce_1"), image.size.height > 0 else {
            return 1.28
        }
        return image.size.width / image.size.height
    }()

    var body: some View {
        ZStack {
            Image(onIceImageName)
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: heroHeight)
                .clipped()
                .contentTransition(.opacity)

            Image("frostFrame")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth, height: heroHeight)
                .opacity(frostFrameOpacity)
                .allowsHitTesting(false)
        }
        .frame(width: screenWidth, height: heroHeight)
        .frame(maxWidth: .infinity)
        .clipped()
        .animation(.easeInOut(duration: 0.35), value: onIceImageName)
        .animation(.easeInOut(duration: 0.35), value: frostFrameOpacity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("On ice, frost \(Int((frostFrameOpacity * 100).rounded())) percent")
    }
}

#Preview {
    VStack(spacing: 16) {
        SessionOnIceHeroView(onIceImageName: "onIce_1", frostFrameOpacity: 0)
        SessionOnIceHeroView(onIceImageName: "onIce_3", frostFrameOpacity: 0.75)
    }
    .mainBackground()
}
