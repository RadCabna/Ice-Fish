import Combine
import SwiftUI

@MainActor
final class KeyboardVisibility: ObservableObject {
    @Published private(set) var isVisible = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        let didHide = NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)

        willShow
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.isVisible = true
            }
            .store(in: &cancellables)

        Publishers.Merge(willHide, didHide)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.isVisible = false
            }
            .store(in: &cancellables)
    }
}
