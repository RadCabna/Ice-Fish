import SwiftUI

struct RulesNotificationsCard: View {
    @ObservedObject var viewModel: RulesViewModel

    private var cornerRadius: CGFloat {
        screenHeight * 0.016
    }

    private let toggleTint = Color(red: 0.35, green: 0.82, blue: 1.0)

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.016) {
            HStack(spacing: screenWidth * 0.025) {
                Image(systemName: "bell.fill")
                    .font(.system(size: screenHeight * 0.018))
                    .foregroundStyle(toggleTint)

                Text("Push Notifications")
                    .font(.system(size: screenHeight * 0.018, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(spacing: screenHeight * 0.018) {
                ForEach(RulesNotificationItem.items) { item in
                    if let binding = viewModel.binding(for: item.id) {
                        notificationRow(item: item, isOn: binding)
                    }
                }
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
                .stroke(Color.white.opacity(0.1), lineWidth: screenHeight * 0.0012)
        )
    }

    private func notificationRow(item: RulesNotificationItem, isOn: Binding<Bool>) -> some View {
        HStack(alignment: .center, spacing: screenWidth * 0.03) {
            VStack(alignment: .leading, spacing: screenHeight * 0.004) {
                Text(item.title)
                    .font(.system(size: screenHeight * 0.016, weight: .medium))
                    .foregroundStyle(.white)

                Text(item.subtitle)
                    .font(.system(size: screenHeight * 0.013))
                    .foregroundStyle(Color.white.opacity(0.5))
            }

            Spacer(minLength: screenWidth * 0.02)

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(toggleTint)
        }
    }
}

#Preview {
    RulesNotificationsCard(viewModel: RulesViewModel())
        .padding()
        .mainBackground()
        .environmentObject(SettingsViewModel())
}
