import SwiftUI

struct SessionPlaceholderImage: View {
    let title: String
    let systemName: String
    var height: CGFloat?

    var body: some View {
        VStack(spacing: screenHeight * 0.01) {
            Image(systemName: systemName)
                .font(.system(size: screenHeight * 0.04))
                .foregroundStyle(Color.white.opacity(0.45))

            Text(title)
                .font(.system(size: screenHeight * 0.014))
                .foregroundStyle(Color.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .frame(height: height ?? screenHeight * 0.22)
        .sessionCardStyle(cornerRadius: screenHeight * 0.018)
    }
}

#Preview {
    SessionPlaceholderImage(title: "Ice Auger Placeholder", systemName: "arrow.triangle.2.circlepath")
        .padding()
        .mainBackground()
}
