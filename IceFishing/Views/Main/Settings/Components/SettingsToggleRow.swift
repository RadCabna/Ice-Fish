import SwiftUI

struct SettingsToggleRow: View {
    let iconName: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    private let toggleTint = Color(red: 0.35, green: 0.82, blue: 1.0)

    var body: some View {
        HStack(alignment: .center, spacing: screenWidth * 0.035) {
            Image(systemName: iconName)
                .font(.system(size: screenHeight * 0.02))
                .foregroundStyle(toggleTint)
                .frame(width: screenHeight * 0.028)

            VStack(alignment: .leading, spacing: screenHeight * 0.004) {
                Text(title)
                    .font(.system(size: screenHeight * 0.016, weight: .medium))
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.system(size: screenHeight * 0.013))
                    .foregroundStyle(Color.white.opacity(0.5))
            }

            Spacer(minLength: screenWidth * 0.02)

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(toggleTint)
        }
    }
}
