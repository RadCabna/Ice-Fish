import SwiftUI

struct AnimatablePercentText: View, Animatable {
    var value: Double
    var fontSize: CGFloat

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    var body: some View {
        Text("\(Int(value.rounded()))%")
            .font(.system(size: fontSize, weight: .bold))
            .foregroundStyle(.white)
            .monospacedDigit()
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true) {
        AnimatablePercentText(value: 46, fontSize: ScreenSize.height * 0.085)
    }
}
