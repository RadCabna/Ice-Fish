import SwiftUI

struct MainTabRoot<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            AppBackground()

            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MainTabRoot {
        Text("Tab Content")
            .foregroundStyle(.white)
    }
    .environmentObject(SettingsViewModel())
}
