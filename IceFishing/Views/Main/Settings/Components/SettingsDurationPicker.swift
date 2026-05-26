import SwiftUI

struct SettingsDurationPicker: View {
    @Binding var selectedMinutes: Int

    private let accent = Color(red: 0.35, green: 0.82, blue: 1.0)

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.012) {
            Text("Default Session Duration")
                .font(.system(size: screenHeight * 0.016, weight: .medium))
                .foregroundStyle(.white)

            VStack(spacing: screenHeight * 0.014) {
                ForEach(SettingsViewModel.durationOptions, id: \.self) { minutes in
                    durationRow(minutes: minutes)
                }
            }
        }
    }

    private func durationRow(minutes: Int) -> some View {
        let isSelected = selectedMinutes == minutes

        return Button {
            selectedMinutes = minutes
        } label: {
            HStack(spacing: screenWidth * 0.03) {
                ZStack {
                    Circle()
                        .stroke(accent, lineWidth: screenHeight * 0.002)
                        .frame(width: screenHeight * 0.022, height: screenHeight * 0.022)

                    if isSelected {
                        Circle()
                            .fill(accent)
                            .frame(width: screenHeight * 0.012, height: screenHeight * 0.012)
                    }
                }

                Text("\(minutes) minutes")
                    .font(.system(size: screenHeight * 0.016))
                    .foregroundStyle(.white)

                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}
