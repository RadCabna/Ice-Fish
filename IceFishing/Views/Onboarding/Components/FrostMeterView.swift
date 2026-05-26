import SwiftUI

struct FrostMeterView: View {
    var progress: Double

    var body: some View {
        VStack(spacing: screenHeight * 0.012) {
            Text("Frost Meter")
                .font(.system(size: screenHeight * 0.018, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.12))
                        .frame(height: screenHeight * 0.009)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color("buttonColor_1"),
                                    Color("buttonColor_2")
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: max(screenHeight * 0.009, geometry.size.width * progress),
                            height: screenHeight * 0.009
                        )
                        .animation(.easeInOut(duration: 0.85), value: progress)
                }
            }
            .frame(height: screenHeight * 0.009)

            HStack {
                Text("0%")
                Spacer()
                Text("100%")
            }
            .font(.system(size: screenHeight * 0.014))
            .foregroundStyle(.white.opacity(0.55))
        }
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true) {
        FrostMeterView(progress: 0.46)
    }
}
