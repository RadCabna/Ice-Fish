import SwiftUI

struct LearnMoreSheet: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: screenHeight * 0.019) {
                    Text("Play within your limits. Set session timers, stop-loss, and take-profit before you start.")
                    Text("If gambling stops being fun, seek help from local responsible gaming resources.")
                }
                .font(.system(size: screenHeight * 0.02))
                .foregroundStyle(.primary)
                .padding(screenWidth * 0.062)
            }
            .navigationTitle("Responsible Play")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LearnMoreSheet()
}
