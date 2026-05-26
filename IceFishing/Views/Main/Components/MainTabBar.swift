import SwiftUI

struct MainTabBar: View {
    @Binding var selectedTab: MainTab

    private let activeLabelColor = Color(red: 0.45, green: 0.92, blue: 1.0)
    private let inactiveLabelColor = Color.white.opacity(0.45)
    private let barCornerRadius = ScreenSize.height * 0.022
    private let itemCornerRadius = ScreenSize.height * 0.014

    var body: some View {
        HStack(spacing: 0) {
            ForEach(MainTab.allCases) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, screenWidth * 0.02)
        .padding(.vertical, screenHeight * 0.012)
        .roundedPanel(
            cornerRadius: barCornerRadius,
            fill: SurfaceStyle.barFill
        )
        .animation(.spring(response: 0.38, dampingFraction: 0.78), value: selectedTab)
    }

    private func tabButton(for tab: MainTab) -> some View {
        let isSelected = selectedTab == tab
        let highlightShape = RoundedRectangle(cornerRadius: itemCornerRadius, style: .continuous)

        return Button {
            withAnimation(.spring(response: 0.38, dampingFraction: 0.78)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: screenHeight * 0.005) {
                Image(tab.iconAssetName(isSelected: isSelected))
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: screenHeight * 0.028,
                        height: screenHeight * 0.028
                    )

                Text(tab.title)
                    .font(.system(size: screenHeight * 0.013, weight: .medium))
                    .foregroundStyle(isSelected ? activeLabelColor : inactiveLabelColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, screenHeight * 0.01)
            .padding(.horizontal, screenWidth * 0.01)
            .background {
                if isSelected {
                    highlightShape
                        .fill(SurfaceStyle.tabHighlightFill)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    MainTabBarPreview()
}

private struct MainTabBarPreview: View {
    @State private var tab: MainTab = .session

    var body: some View {
        ZStack {
            MainBackground()
            VStack {
                Spacer()
                MainTabBar(selectedTab: $tab)
                    .padding(.horizontal, ScreenSize.width * 0.05)
            }
        }
    }
}
