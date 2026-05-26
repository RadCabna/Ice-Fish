import SwiftUI

struct HoldToReelButton: View {
    let onComplete: () -> Void

    @State private var holdProgress: CGFloat = 0
    @State private var isHolding = false

    private let holdDuration: Double = 2

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.white.opacity(0.15))

            GeometryReader { geometry in
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.45, blue: 0.15),
                                Color(red: 1.0, green: 0.25, blue: 0.2)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(0, geometry.size.width * holdProgress))
            }

            HStack(spacing: screenWidth * 0.02) {
                Circle()
                    .fill(Color.red.opacity(0.9))
                    .frame(width: screenHeight * 0.012, height: screenHeight * 0.012)

                Text(isHolding ? "Reeling Out..." : "Hold to Reel Out")
                    .font(.system(size: screenHeight * 0.02, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(minHeight: screenHeight * 0.062)
        .clipShape(Capsule())
        .contentShape(Capsule())
        .gesture(holdGesture)
        .accessibilityLabel("Hold to reel out")
    }

    private var holdGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                if !isHolding {
                    isHolding = true
                    startHoldTimer()
                }
            }
            .onEnded { _ in
                cancelHold()
            }
    }

    private func startHoldTimer() {
        holdProgress = 0
        withAnimation(.linear(duration: holdDuration)) {
            holdProgress = 1
        }
        Task {
            try? await Task.sleep(for: .seconds(holdDuration))
            guard isHolding, holdProgress >= 0.99 else { return }
            await MainActor.run {
                isHolding = false
                holdProgress = 0
                onComplete()
            }
        }
    }

    private func cancelHold() {
        isHolding = false
        withAnimation(.easeOut(duration: 0.2)) {
            holdProgress = 0
        }
    }
}

#Preview {
    HoldToReelButton(onComplete: {})
        .padding()
        .mainBackground()
}
