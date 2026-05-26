import SwiftUI

struct SessionProgressBar: View {
    let progress: Double
    let fillColors: [Color]
    var trackOpacity: Double = 0.12

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(trackOpacity))

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: fillColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(screenHeight * 0.008, geometry.size.width * min(1, max(0, progress))))
            }
        }
        .frame(height: screenHeight * 0.009)
    }
}

#Preview {
    SessionProgressBar(
        progress: 0.45,
        fillColors: [Color.green, Color(red: 0.3, green: 0.9, blue: 0.5)]
    )
    .padding()
    .frame(height: 20)
    .mainBackground()
}
