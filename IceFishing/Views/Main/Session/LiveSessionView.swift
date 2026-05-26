import SwiftUI

struct LiveSessionView: View {
    @ObservedObject var viewModel: LiveSessionViewModel
    let onFinish: () -> Void

    private var horizontalInset: CGFloat {
        screenWidth * 0.05
    }

    private var catchColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: screenWidth * 0.03),
            GridItem(.flexible(), spacing: screenWidth * 0.03)
        ]
    }

    private var isIceLocked: Bool {
        viewModel.isSessionBlocked
    }

    private var frostBarColors: [Color] {
        if isIceLocked {
            return [
                Color(red: 1.0, green: 0.55, blue: 0.2),
                Color(red: 1.0, green: 0.3, blue: 0.25)
            ]
        }
        return [
            Color(red: 0.35, green: 0.78, blue: 1.0),
            Color(red: 0.55, green: 0.88, blue: 1.0)
        ]
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: screenHeight * 0.014) {
                Text("On The Ice")
                    .font(.system(size: screenHeight * 0.034, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, horizontalInset)

                statsRow

                onIceHero

                if !isIceLocked {
                    catchGrid
                    stopGoalSection
                }

                frostMeterSection

                if !isIceLocked, let message = viewModel.frostWarningMessage {
                    Text(message)
                        .font(.system(size: screenHeight * 0.014, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, screenWidth * 0.06)
                }

                Text("Cold mind makes better decisions.")
                    .font(.system(size: screenHeight * 0.013))
                    .foregroundStyle(Color.white.opacity(0.4))

                footerAction
                    .padding(.horizontal, horizontalInset)
            }
            .padding(.top, screenHeight * 0.015)
            .padding(.bottom, screenHeight * 0.02)
        }
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden(true)
        .colorScheme(.dark)
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.35), value: isIceLocked)
        .onDisappear {
            viewModel.stop()
        }
    }

    @ViewBuilder
    private var footerAction: some View {
        if isIceLocked {
            SessionReelOutButton(action: onFinish)
        } else {
            HoldToReelButton(onComplete: onFinish)
        }
    }

    private var onIceHero: some View {
        SessionOnIceHeroView(
            onIceImageName: viewModel.onIceImageName,
            frostFrameOpacity: viewModel.frostFrameOpacity
        )
        .id("sessionOnIceHero")
        .animation(.easeInOut(duration: 0.35), value: viewModel.onIceImageName)
    }

    private var statsRow: some View {
        HStack(spacing: screenWidth * 0.025) {
            SessionStatCard(
                iconName: "clock.fill",
                iconColor: Color(red: 0.35, green: 0.85, blue: 1.0),
                value: viewModel.formattedTime,
                title: "Time"
            )
            SessionStatCard(
                iconName: "gauge.with.dots.needle.33percent",
                iconColor: Color(red: 1.0, green: 0.55, blue: 0.2),
                value: viewModel.frostPercentLabel,
                title: "Frost"
            )
            SessionStatCard(
                iconName: "chart.line.uptrend.xyaxis",
                iconColor: viewModel.balance >= 0
                    ? Color(red: 0.35, green: 0.9, blue: 0.55)
                    : Color(red: 1.0, green: 0.35, blue: 0.35),
                value: viewModel.formattedBalance,
                title: "Balance",
                valueColor: viewModel.balance >= 0 ? .white : Color.red
            )
        }
        .padding(.horizontal, horizontalInset)
    }

    private var catchGrid: some View {
        LazyVGrid(columns: catchColumns, spacing: screenHeight * 0.012) {
            ForEach(CatchEventType.allCases) { type in
                SessionCatchButton(
                    type: type,
                    isEnabled: viewModel.canLogCatch
                ) {
                    viewModel.logCatch(type)
                }
            }
        }
        .padding(.horizontal, horizontalInset)
    }

    private var stopGoalSection: some View {
        VStack(spacing: SessionMetricStyle.rowSpacing) {
            HStack {
                Text("Stop: -$\(Int(viewModel.config.stopLoss))")
                Spacer()
                Text("Goal: +$\(Int(viewModel.config.takeProfit))")
            }
            .font(.system(size: SessionMetricStyle.labelFontSize, weight: .medium))
            .foregroundStyle(Color.white.opacity(0.88))

            SessionCenteredBalanceBar(
                profitProgress: viewModel.profitProgress,
                lossProgress: viewModel.lossProgress
            )
        }
        .sessionMetricPanelStyle()
        .padding(.horizontal, horizontalInset)
    }

    private var frostMeterSection: some View {
        VStack(spacing: SessionMetricStyle.rowSpacing) {
            HStack {
                Text("Frost Meter")
                    .font(.system(size: SessionMetricStyle.labelFontSize, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.88))
                Spacer()
                Text(viewModel.frostPercentLabel)
                    .font(.system(size: SessionMetricStyle.valueFontSize, weight: .semibold))
                    .foregroundStyle(.white)
            }

            SessionProgressBar(
                progress: min(1, viewModel.frostPercent / 100),
                fillColors: frostBarColors
            )
            .frame(height: SessionMetricStyle.barHeight)
        }
        .sessionMetricPanelStyle()
        .padding(.horizontal, horizontalInset)
    }
}

#Preview("Active Session") {
    ZStack {
        MainBackground()
        LiveSessionView(
            viewModel: LiveSessionViewModel(
                config: SessionConfig(stopLoss: 10, takeProfit: 20, timerMinutes: 30)
            ),
            onFinish: {}
        )
    }
}

#Preview("Ice Lock") {
    IceLockPreviewHost()
}

private struct IceLockPreviewHost: View {
    @StateObject private var viewModel = LiveSessionViewModel(
        config: SessionConfig(stopLoss: 10, takeProfit: 20, timerMinutes: 30)
    )

    var body: some View {
        ZStack {
            MainBackground()
            LiveSessionView(viewModel: viewModel, onFinish: {})
        }
        .onAppear {
            viewModel.applyPreviewIceLock(
                elapsedSeconds: 34 * 60 + 55,
                balance: -15
            )
        }
    }
}
