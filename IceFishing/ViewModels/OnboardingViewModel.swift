import Foundation
import SwiftUI

enum OnboardingPage: Int, CaseIterable {
    case intro = 0
    case session = 1
    case frost = 2
    case responsible = 3
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentPage: OnboardingPage = .intro
    @Published private(set) var displayedFrostPercent: Double = 4
    @Published private(set) var hasConfirmedAge = false

    let frostDemoLevels = [4, 46, 87, 23, 62, 91]
    let sessionTimer = "30:00"
    let stopLoss = "$50.00"
    let takeProfit = "$100.00"
    let frostWarning = "45%"

    var currentPageIndex: Int {
        currentPage.rawValue
    }

    var totalPages: Int {
        OnboardingPage.allCases.count
    }

    var primaryButtonTitle: String {
        switch currentPage {
        case .intro, .frost:
            return "Continue"
        case .session:
            return "Next"
        case .responsible:
            return "Start Fishing"
        }
    }

    var isLastPage: Bool {
        currentPage == .responsible
    }

    func advance() {
        guard let next = OnboardingPage(rawValue: currentPage.rawValue + 1) else { return }
        currentPage = next
    }

    func goToPage(_ page: OnboardingPage) {
        currentPage = page
    }

    private var frostDemoTask: Task<Void, Never>?

    var displayedFrostProgress: Double {
        displayedFrostPercent / 100
    }

    func startFrostDemoCycle() {
        frostDemoTask?.cancel()
        displayedFrostPercent = Double(frostDemoLevels[0])
        var nextIndex = 1

        frostDemoTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2))
                guard !Task.isCancelled else { return }

                let target = Double(frostDemoLevels[nextIndex])
                withAnimation(.easeInOut(duration: 0.85)) {
                    displayedFrostPercent = target
                }
                nextIndex = (nextIndex + 1) % frostDemoLevels.count
            }
        }
    }

    func stopFrostDemoCycle() {
        frostDemoTask?.cancel()
        frostDemoTask = nil
    }

    func resetAgeConfirmation() {
        hasConfirmedAge = false
    }

    func confirmAge() {
        hasConfirmedAge = true
    }

    var canStartFishing: Bool {
        hasConfirmedAge
    }
}
