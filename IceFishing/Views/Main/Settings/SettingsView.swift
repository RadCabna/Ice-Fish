import SwiftUI

struct SettingsView: View {
    @ObservedObject var journalViewModel: JournalViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel

    private var horizontalInset: CGFloat {
        screenWidth * 0.05
    }

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: screenHeight * 0.018) {
                    header

                    generalSection

                    sessionDefaultsSection

                    legalSection

                    dataManagementSection

                    footer
                }
                .padding(.horizontal, horizontalInset)
                .padding(.bottom, screenHeight * 0.12)
            }
            .scrollContentBackground(.hidden)

            if settingsViewModel.showsClearHistoryAlert {
                AppConfirmationAlert(
                    title: "Clear All Session History?",
                    message: "This will permanently remove every saved session from your journal.",
                    confirmTitle: "Clear All",
                    onConfirm: {
                        settingsViewModel.cancelClearHistory()
                        journalViewModel.clearAllSessions()
                    },
                    onCancel: { settingsViewModel.cancelClearHistory() }
                )
            }
        }
        .mainBackground()
        .navigationBarHidden(true)
        .preferredColorScheme(settingsViewModel.darkModeEnabled ? .dark : .light)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.006) {
            Text("Cabin Settings")
                .font(.system(size: screenHeight * 0.034, weight: .bold))
                .foregroundStyle(.white)

            Text("Customize your experience")
                .font(.system(size: screenHeight * 0.016))
                .foregroundStyle(Color.white.opacity(0.55))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, screenHeight * 0.02)
    }

    private var generalSection: some View {
        SettingsSectionCard(title: "General") {
            VStack(spacing: screenHeight * 0.018) {
                SettingsToggleRow(
                    iconName: "bell",
                    title: "Notifications",
                    subtitle: "Session alerts and reminders",
                    isOn: $settingsViewModel.notificationsEnabled
                )

                SettingsToggleRow(
                    iconName: "speaker.wave.2",
                    title: "Sound Effects",
                    subtitle: "Audio feedback",
                    isOn: $settingsViewModel.soundEffectsEnabled
                )

                SettingsToggleRow(
                    iconName: "moon",
                    title: "Dark Mode",
                    subtitle: "Always-on icy theme",
                    isOn: $settingsViewModel.darkModeEnabled
                )
            }
        }
    }

    private var sessionDefaultsSection: some View {
        SettingsSectionCard(title: "Session Defaults") {
            SettingsDurationPicker(selectedMinutes: $settingsViewModel.defaultSessionMinutes)
        }
    }

    private var legalSection: some View {
        SettingsLegalSafetyCard(
            onPrivacyPolicyTap: openPrivacyPolicy,
            onResponsiblePlayTap: openResponsiblePlayDisclaimer
        )
    }

    private func openPrivacyPolicy() {
        // Safari URL will be added later.
    }

    private func openResponsiblePlayDisclaimer() {
        // Safari URL will be added later.
    }

    private var dataManagementSection: some View {
        SettingsSectionCard(title: "Data Management") {
            Button {
                settingsViewModel.requestClearHistory()
            } label: {
                HStack(spacing: screenWidth * 0.025) {
                    Image(systemName: "trash")
                        .font(.system(size: screenHeight * 0.016, weight: .semibold))

                    Text("Clear All Session History")
                        .font(.system(size: screenHeight * 0.016, weight: .medium))
                }
                .foregroundStyle(Color.white.opacity(0.9))
                .frame(maxWidth: .infinity)
                .frame(minHeight: screenHeight * 0.052)
                .background(
                    RoundedRectangle(cornerRadius: screenHeight * 0.012, style: .continuous)
                        .fill(Color(red: 0.42, green: 0.1, blue: 0.14))
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var footer: some View {
        VStack(spacing: screenHeight * 0.008) {
            Image("frostIcon")
                .resizable()
                .scaledToFit()
                .frame(width: screenHeight * 0.028, height: screenHeight * 0.028)

            Text("IceFishing: Mind Tracker")
                .font(.system(size: screenHeight * 0.015, weight: .medium))
                .foregroundStyle(Color.white.opacity(0.55))

            Text("Version 1.0.0")
                .font(.system(size: screenHeight * 0.013))
                .foregroundStyle(Color.white.opacity(0.4))

            Text("Play responsibly. Set limits. Stop if the game stops being fun.")
                .font(.system(size: screenHeight * 0.012))
                .foregroundStyle(Color.white.opacity(0.4))
                .multilineTextAlignment(.center)
                .padding(.top, screenHeight * 0.004)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, screenHeight * 0.01)
    }

}

#Preview {
    SettingsView(
        journalViewModel: JournalViewModel(loadStoredSessions: false),
        settingsViewModel: SettingsViewModel()
    )
    .environmentObject(SettingsViewModel())
}
