import SwiftUI

struct MainBackground: View {
    var body: some View {
        LinearGradient(
            colors: [Color("bgColor_1"), Color("bgColor_2")],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct JournalDetailBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.1, blue: 0.24),
                Color(red: 0.12, green: 0.52, blue: 0.78)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct AppBackground: View {
    @EnvironmentObject private var settings: SettingsViewModel

    var body: some View {
        Group {
            if settings.darkModeEnabled {
                MainBackground()
            } else {
                JournalDetailBackground()
            }
        }
    }
}

extension View {
    func mainBackground() -> some View {
        background {
            AppBackground()
        }
    }
}

#Preview {
    AppBackground()
        .environmentObject(SettingsViewModel())
}
