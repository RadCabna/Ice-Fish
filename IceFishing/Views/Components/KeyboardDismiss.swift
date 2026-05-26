import SwiftUI
import UIKit

enum KeyboardDismiss {
    static func dismiss() {
        guard let window = keyWindow else { return }
        window.endEditing(true)
    }

    private static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
    }
}

@MainActor
final class KeyboardDismissController: NSObject, UIGestureRecognizerDelegate {
    static let shared = KeyboardDismissController()

    private weak var hostView: UIView?
    private var tapRecognizer: UITapGestureRecognizer?

    private override init() {
        super.init()
    }

    func install() {
        guard let hostView = resolveHostView() else { return }
        if self.hostView === hostView, tapRecognizer != nil {
            return
        }

        uninstall()

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        hostView.addGestureRecognizer(tap)
        tapRecognizer = tap
        self.hostView = hostView
    }

    func uninstall() {
        if let tapRecognizer, let hostView = tapRecognizer.view {
            hostView.removeGestureRecognizer(tapRecognizer)
        }
        tapRecognizer = nil
        hostView = nil
    }

    @objc private func handleTap() {
        KeyboardDismiss.dismiss()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        !isTextInputTouch(touch)
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }

    private func isTextInputTouch(_ touch: UITouch) -> Bool {
        var view = touch.view
        while let current = view {
            if current is UITextField || current is UITextView {
                return true
            }
            if current is UIControl {
                return true
            }
            let typeName = String(describing: type(of: current))
            if typeName.contains("TextField")
                || typeName.contains("TextEditor")
                || typeName.contains("TextInput")
                || typeName.contains("_UIText") {
                return true
            }
            view = current.superview
        }
        return false
    }

    private func resolveHostView() -> UIView? {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
        else {
            return nil
        }

        if let rootView = window.rootViewController?.view {
            return rootView
        }
        return window
    }
}

private struct KeyboardDismissInstaller: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> InstallerViewController {
        InstallerViewController()
    }

    func updateUIViewController(_ uiViewController: InstallerViewController, context: Context) {
        uiViewController.scheduleInstall()
    }

    final class InstallerViewController: UIViewController {
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            scheduleInstall()
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            scheduleInstall()
        }

        func scheduleInstall() {
            DispatchQueue.main.async {
                KeyboardDismissController.shared.install()
            }
        }
    }
}

extension View {
    func dismissKeyboardOnTapOutside() -> some View {
        background {
            KeyboardDismissInstaller()
                .frame(width: 1, height: 1)
                .opacity(0)
                .allowsHitTesting(false)
        }
    }
}
