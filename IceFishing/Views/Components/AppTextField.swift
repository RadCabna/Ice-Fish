import SwiftUI

struct AppTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    private let fieldBackground = Color(red: 0.96, green: 0.96, blue: 0.97)
    private let fieldBorder = Color(red: 0.82, green: 0.84, blue: 0.86)
    private let textColor = Color(red: 0.11, green: 0.11, blue: 0.12)
    private let placeholderColor = Color(red: 0.55, green: 0.57, blue: 0.60)
    private let labelColor = Color(red: 0.25, green: 0.27, blue: 0.31)

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.007) {
            Text(title)
                .font(.system(size: screenHeight * 0.018, weight: .medium))
                .foregroundStyle(labelColor)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: screenHeight * 0.02))
                        .foregroundStyle(placeholderColor)
                }

                TextField("", text: $text)
                    .font(.system(size: screenHeight * 0.02))
                    .foregroundStyle(textColor)
                    .tint(textColor)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(.sentences)
                    .autocorrectionDisabled()
            }
            .padding(.horizontal, screenWidth * 0.036)
            .frame(maxWidth: .infinity, minHeight: screenHeight * 0.057, alignment: .leading)
            .roundedPanel(
                cornerRadius: screenHeight * 0.012,
                fill: fieldBackground,
                stroke: fieldBorder,
                lineWidth: screenHeight * 0.0012
            )
        }
    }
}

#Preview {
    @Previewable @State var text = ""

    PreviewHost {
        AppTextField(
            title: "Species",
            placeholder: "e.g. Perch",
            text: $text
        )
    }
}
