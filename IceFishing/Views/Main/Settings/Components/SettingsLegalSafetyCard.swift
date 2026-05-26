import SwiftUI

struct SettingsLegalSafetyCard: View {
    var onPrivacyPolicyTap: () -> Void = {}
    var onResponsiblePlayTap: () -> Void = {}

    private let accent = Color(red: 0.35, green: 0.82, blue: 1.0)
    private let iconColumnWidth: CGFloat = ScreenSize.height * 0.028

    private var cornerRadius: CGFloat {
        screenHeight * 0.016
    }

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.018) {
            HStack(spacing: screenWidth * 0.035) {
                Image("protectIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconColumnWidth, height: iconColumnWidth)

                Text("Legal & Safety")
                    .font(.system(size: screenHeight * 0.018, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: screenHeight * 0.014) {
                legalLink(title: "Privacy Policy", action: onPrivacyPolicyTap)
                legalLink(title: "Responsible Play Disclaimer", action: onResponsiblePlayTap)
            }
        }
        .padding(.horizontal, screenWidth * 0.045)
        .padding(.vertical, screenHeight * 0.018)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color(red: 0.1, green: 0.16, blue: 0.28))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(accent.opacity(0.55), lineWidth: screenHeight * 0.0014)
        )
    }

    private func legalLink(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: screenWidth * 0.035) {
                Image(systemName: "doc.text")
                    .font(.system(size: screenHeight * 0.018))
                    .foregroundStyle(.white)
                    .frame(width: iconColumnWidth)

                Text(title)
                    .font(.system(size: screenHeight * 0.016))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsLegalSafetyCard()
        .padding()
        .mainBackground()
        .environmentObject(SettingsViewModel())
}
