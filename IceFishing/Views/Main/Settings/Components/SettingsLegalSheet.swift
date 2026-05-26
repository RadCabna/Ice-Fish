import SwiftUI

struct SettingsLegalSheet: View {
    let title: String
    let bodyText: String
    let onClose: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.1, blue: 0.24),
                    Color(red: 0.12, green: 0.52, blue: 0.78)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: screenHeight * 0.02) {
                Text(title)
                    .font(.system(size: screenHeight * 0.022, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ScrollView(showsIndicators: false) {
                    Text(bodyText)
                        .font(.system(size: screenHeight * 0.016))
                        .foregroundStyle(Color.white.opacity(0.75))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: onClose) {
                    Text("Close")
                        .font(.system(size: screenHeight * 0.02, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: screenHeight * 0.058)
                        .background {
                            RoundedRectangle(cornerRadius: screenHeight * 0.014, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.28, green: 0.72, blue: 0.98),
                                            Color(red: 0.14, green: 0.48, blue: 0.88)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                }
                .buttonStyle(.plain)
            }
            .padding(screenWidth * 0.06)
            .frame(maxWidth: screenWidth * 0.9, maxHeight: screenHeight * 0.7)
            .background(
                RoundedRectangle(cornerRadius: screenHeight * 0.02, style: .continuous)
                    .fill(Color(red: 0.08, green: 0.14, blue: 0.28).opacity(0.95))
            )
        }
        .colorScheme(.dark)
    }
}
