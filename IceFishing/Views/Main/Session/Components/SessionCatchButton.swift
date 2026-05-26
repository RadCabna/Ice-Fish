import SwiftUI

struct SessionCatchButton: View {
    let type: CatchEventType
    let isEnabled: Bool
    let action: () -> Void

    private var cornerRadius: CGFloat {
        screenHeight * 0.016
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: screenHeight * 0.008) {
                Image(systemName: iconName)
                    .font(.system(size: screenHeight * 0.028))
                    .foregroundStyle(.white.opacity(0.9))

                Text(type.title)
                    .font(.system(size: screenHeight * 0.015, weight: .medium))
                    .foregroundStyle(.white)

                Text(type.deltaLabel)
                    .font(.system(size: screenHeight * 0.014, weight: .semibold))
                    .foregroundStyle(amountColor)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: screenHeight * 0.11)
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(tileColor.opacity(isEnabled ? 1 : 0.45))
            }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }

    private var tileColor: Color {
        switch type {
        case .smallFish:
            return Color(red: 0.1, green: 0.34, blue: 0.28)
        case .bigFish:
            return Color(red: 0.09, green: 0.17, blue: 0.34)
        case .bonus:
            return Color(red: 0.24, green: 0.12, blue: 0.38)
        case .deadIce:
            return Color(red: 0.11, green: 0.15, blue: 0.26)
        }
    }

    private var amountColor: Color {
        switch type {
        case .smallFish:
            return Color(red: 0.35, green: 0.95, blue: 0.55)
        case .bigFish:
            return Color(red: 0.45, green: 0.82, blue: 1.0)
        case .bonus:
            return Color(red: 0.78, green: 0.55, blue: 1.0)
        case .deadIce:
            return Color.white.opacity(0.55)
        }
    }

    private var iconName: String {
        switch type {
        case .smallFish:
            return "fish.fill"
        case .bigFish:
            return "fish"
        case .bonus:
            return "figure.fishing"
        case .deadIce:
            return "snowflake"
        }
    }
}

#Preview {
    LazyVGrid(
        columns: [GridItem(.flexible()), GridItem(.flexible())],
        spacing: ScreenSize.height * 0.012
    ) {
        ForEach(CatchEventType.allCases) { type in
            SessionCatchButton(type: type, isEnabled: true) {}
        }
    }
    .padding()
    .mainBackground()
}
