import SwiftUI

struct SessionControlCard: View {
    let iconName: String
    let iconColor: Color
    let title: String
    let value: String

    private var iconContainerSize: CGFloat {
        screenHeight * 0.052
    }

    private var cornerRadius: CGFloat {
        screenHeight * 0.017
    }

    var body: some View {
        HStack(spacing: screenWidth * 0.036) {
            ZStack {
                RoundedRectangle(cornerRadius: screenHeight * 0.012, style: .continuous)
                    .fill(iconColor.opacity(0.22))

                Image(iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: screenHeight * 0.028,
                        height: screenHeight * 0.028
                    )
            }
            .frame(width: iconContainerSize, height: iconContainerSize)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: screenHeight * 0.02, weight: .medium))
                    .foregroundStyle(.white)

                Text(value)
                    .font(.system(size: screenHeight * 0.02, weight: .semibold))
                    .foregroundStyle(.white)
            }
            Spacer()
        }
        .padding(.horizontal, screenWidth * 0.046)
        .frame(minHeight: screenHeight * 0.1)
        .roundedPanel(
            cornerRadius: cornerRadius,
            fill: SurfaceStyle.subtleFill,
            stroke: Color.white.opacity(0.1),
            lineWidth: screenHeight * 0.0012
        )
    }
}

#Preview {
    PreviewHost(useOnboardingBackground: true) {
        VStack(spacing: ScreenSize.height * 0.014) {
            SessionControlCard(
                iconName: "timerIcon",
                iconColor: Color(red: 0.35, green: 0.65, blue: 1.0),
                title: "Session Timer",
                value: "30:00"
            )
            SessionControlCard(
                iconName: "stopIcon",
                iconColor: Color(red: 1.0, green: 0.35, blue: 0.35),
                title: "Stop-Loss",
                value: "$50.00"
            )
        }
    }
}
