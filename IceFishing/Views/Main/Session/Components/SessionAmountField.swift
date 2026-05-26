import SwiftUI

struct SessionAmountField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var onChange: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.008) {
            Text(title)
                .font(.system(size: screenHeight * 0.016))
                .foregroundStyle(Color.white.opacity(0.55))

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: SessionStyle.fieldCornerRadius, style: .continuous)
                    .fill(SessionStyle.fieldFill)

                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(.system(size: screenHeight * 0.022, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.35))
                            .allowsHitTesting(false)
                            .padding(.horizontal, screenWidth * 0.04)
                    }

                    TextField("", text: $text)
                        .font(.system(size: screenHeight * 0.022, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .tint(Color(red: 0.35, green: 0.82, blue: 1.0))
                        .keyboardType(.decimalPad)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.horizontal, screenWidth * 0.04)
                        .keyboardDoneAccessory()
                        .onChange(of: text) { _, _ in onChange() }
                }
            }
            .frame(maxWidth: .infinity, minHeight: screenHeight * 0.058, alignment: .leading)
            .colorScheme(.dark)
        }
        .padding(screenWidth * 0.04)
        .sessionCardStyle()
    }
}

#Preview {
    @Previewable @State var text = ""

    ZStack {
        MainBackground()
        SessionAmountField(
            title: "Stop-Loss Amount",
            placeholder: "$ 0.00",
            text: $text
        )
        .padding()
    }
}
