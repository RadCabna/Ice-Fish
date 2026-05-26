import SwiftUI

struct SessionDrillHeroView: View {
    let pulseToken: Int

    @State private var scale: CGFloat = 1
    @State private var glowStrength: Double = 0.72
    @State private var innerShadowRadius: CGFloat = 0
    @State private var outerShadowRadius: CGFloat = 0
    @State private var pulseTask: Task<Void, Never>?

    private let coldGlow = Color(red: 0.38, green: 0.9, blue: 1.0)
    private let dotSize = ScreenSize.height * 0.044

    var body: some View {
        ZStack {
            Image("drillImage")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)

            Image("drillDot")
                .resizable()
                .scaledToFit()
                .frame(width: dotSize, height: dotSize)
                .scaleEffect(scale)
                .shadow(color: coldGlow.opacity(glowStrength), radius: innerShadowRadius)
                .shadow(color: coldGlow.opacity(glowStrength * 0.75), radius: outerShadowRadius)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Ice drill")
        .onAppear {
            applyRestingShadow(animated: false)
        }
        .onChange(of: pulseToken) { _, newValue in
            guard newValue > 0 else { return }
            runPulse()
        }
    }

    private func applyRestingShadow(animated: Bool) {
        let resting = {
            innerShadowRadius = dotSize * 0.62
            outerShadowRadius = dotSize * 1.25
            glowStrength = 0.72
            scale = 1
        }
        if animated {
            withAnimation(.spring(response: 0.16, dampingFraction: 0.62)) {
                resting()
            }
        } else {
            resting()
        }
    }

    private func runPulse() {
        pulseTask?.cancel()
        pulseTask = Task { @MainActor in
            withAnimation(.spring(response: 0.14, dampingFraction: 0.42)) {
                scale = 1.32
                glowStrength = 1
                innerShadowRadius = dotSize * 1.15
                outerShadowRadius = dotSize * 2.35
            }

            try? await Task.sleep(for: .milliseconds(55))

            guard !Task.isCancelled else { return }

            withAnimation(.spring(response: 0.18, dampingFraction: 0.55)) {
                scale = 1
                glowStrength = 0.72
                innerShadowRadius = dotSize * 0.62
                outerShadowRadius = dotSize * 1.25
            }
        }
    }
}

#Preview {
    ZStack {
        MainBackground()
        SessionDrillHeroView(pulseToken: 0)
    }
}
