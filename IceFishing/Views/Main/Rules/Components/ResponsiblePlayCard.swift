import SwiftUI

struct ResponsiblePlayCard: View {
    private var cornerRadius: CGFloat {
        screenHeight * 0.016
    }

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.016) {
            Text("Responsible Play")
                .font(.system(size: screenHeight * 0.018, weight: .semibold))
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: screenHeight * 0.014) {
                ForEach(ResponsiblePlayItem.items) { item in
                    VStack(alignment: .leading, spacing: screenHeight * 0.005) {
                        Text(item.label)
                            .font(.system(size: screenHeight * 0.014, weight: .semibold))
                            .foregroundStyle(.white)

                        Text(item.text)
                            .font(.system(size: screenHeight * 0.014))
                            .foregroundStyle(Color.white.opacity(0.55))
                            .fixedSize(horizontal: false, vertical: true)
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
}

#Preview {
    ResponsiblePlayCard()
        .padding()
        .mainBackground()
}
