import SwiftUI

struct SessionCompleteView: View {
    let summary: SessionSummary
    let onSave: (String) -> Void
    let onViewAnalytics: (String) -> Void
    let onDelete: () -> Void

    @State private var noteText = ""
    @State private var isSaving = false

    private let quickTags = [
        "Cold streak after 20 minutes",
        "Big bonus saved the session",
        "Lost focus"
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: screenHeight * 0.02) {
                header

                SessionCompleteHeroView(isProfitable: summary.isProfitable)

                resultCard

                noteSection

                OnboardingGradientButton(title: "Save Session") {
                    guard !isSaving else { return }
                    isSaving = true
                    KeyboardDismiss.dismiss()
                    Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(300))
                        onSave(noteText)
                        isSaving = false
                    }
                }
                .disabled(isSaving)

                HStack(spacing: screenWidth * 0.03) {
                    secondaryButton(title: "View Analytics") {
                        onViewAnalytics(noteText)
                    }
                    secondaryButton(title: "Delete Session", action: onDelete)
                }
            }
            .padding(.horizontal, screenWidth * 0.05)
            .padding(.vertical, screenHeight * 0.02)
        }
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    private var header: some View {
        VStack(spacing: screenHeight * 0.006) {
            Text("Session Complete")
                .font(.system(size: screenHeight * 0.032, weight: .bold))
                .foregroundStyle(.white)

            Text("Fishing results")
                .font(.system(size: screenHeight * 0.016))
                .foregroundStyle(Color.white.opacity(0.55))
        }
    }

    private var resultCard: some View {
        VStack(spacing: screenHeight * 0.016) {
            VStack(spacing: screenHeight * 0.006) {
                Text(summary.formattedBalance)
                    .font(.system(size: screenHeight * 0.028, weight: .bold))
                    .foregroundStyle(.white)

                Text(summary.isProfitable ? "Profitable Session" : "Loss Session")
                    .font(.system(size: screenHeight * 0.016))
                    .foregroundStyle(.white.opacity(0.85))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, screenHeight * 0.018)
            .background {
                RoundedRectangle(cornerRadius: screenHeight * 0.014, style: .continuous)
                    .fill(
                        summary.isProfitable
                            ? Color(red: 0.1, green: 0.45, blue: 0.28)
                            : Color(red: 0.45, green: 0.12, blue: 0.14)
                    )
            }

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: screenHeight * 0.012
            ) {
                statItem(icon: "clock.fill", title: "Duration", value: durationLabel)
                statItem(icon: "gauge.with.dots.needle.33percent", title: "Frost Peak", value: "\(summary.frostPeakPercent)%")
                statItem(icon: "chart.line.uptrend.xyaxis", title: "Big Catches", value: "\(summary.bigCatchCount)")
                statItem(icon: "fish.fill", title: "Bonuses", value: "\(summary.bonusCount)")
            }

            Text(summary.endedAt, format: .dateTime.day().month().year().hour().minute())
                .font(.system(size: screenHeight * 0.013))
                .foregroundStyle(Color.white.opacity(0.4))
        }
        .padding(screenWidth * 0.04)
        .sessionCardStyle(cornerRadius: screenHeight * 0.018)
    }

    private var noteSection: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            Text("Add Session Note")
                .font(.system(size: screenHeight * 0.016))
                .foregroundStyle(Color.white.opacity(0.55))

            ZStack(alignment: .topLeading) {
                if noteText.isEmpty {
                    Text("Optional notes about this session...")
                        .font(.system(size: screenHeight * 0.016))
                        .foregroundStyle(Color.white.opacity(0.3))
                        .padding(.horizontal, screenWidth * 0.04)
                        .padding(.vertical, screenHeight * 0.014)
                }

                TextEditor(text: $noteText)
                    .font(.system(size: screenHeight * 0.016))
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: screenHeight * 0.1)
                    .padding(.horizontal, screenWidth * 0.03)
                    .padding(.vertical, screenHeight * 0.008)
            }
            .frame(maxWidth: .infinity, minHeight: screenHeight * 0.1, alignment: .topLeading)
            .roundedPanel(
                cornerRadius: screenHeight * 0.014,
                fill: SurfaceStyle.fieldFill
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: screenWidth * 0.02) {
                    ForEach(quickTags, id: \.self) { tag in
                        Button {
                            noteText = tag
                        } label: {
                            Text(tag)
                                .font(.system(size: screenHeight * 0.012))
                                .foregroundStyle(Color.white.opacity(0.7))
                                .padding(.horizontal, screenWidth * 0.03)
                                .padding(.vertical, screenHeight * 0.008)
                                .background {
                                    Capsule()
                                        .fill(Color.white.opacity(0.1))
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var durationLabel: String {
        let minutes = summary.durationSeconds / 60
        let seconds = summary.durationSeconds % 60
        if minutes > 0 {
            return "\(minutes) min"
        }
        return "\(seconds) sec"
    }

    private func statItem(icon: String, title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.004) {
            Image(systemName: icon)
                .font(.system(size: screenHeight * 0.014))
                .foregroundStyle(Color.white.opacity(0.6))

            Text(value)
                .font(.system(size: screenHeight * 0.018, weight: .bold))
                .foregroundStyle(.white)

            Text(title)
                .font(.system(size: screenHeight * 0.012))
                .foregroundStyle(Color.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(screenWidth * 0.03)
        .roundedPanel(
            cornerRadius: screenHeight * 0.012,
            fill: Color.white.opacity(0.04)
        )
    }

    private func secondaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: screenHeight * 0.016, weight: .medium))
                .foregroundStyle(.white.opacity(0.85))
                .frame(maxWidth: .infinity)
                .frame(minHeight: screenHeight * 0.052)
                .roundedPanel(
                    cornerRadius: screenHeight * 0.014,
                    fill: Color.white.opacity(0.1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        MainBackground()
        SessionCompleteView(
            summary: SessionSummary(
                balance: 55,
                durationSeconds: 60,
                frostPeakPercent: 12,
                bigCatchCount: 1,
                bonusCount: 1,
                smallCatchCount: 1,
                endedAt: Date()
            ),
            onSave: { _ in },
            onViewAnalytics: { _ in },
            onDelete: {}
        )
    }
}
