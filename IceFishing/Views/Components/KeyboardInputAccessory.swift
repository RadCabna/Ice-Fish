import SwiftUI
import UIKit

enum KeyboardInputAccessory {
    static func makeToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = .black
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 0.35, green: 0.82, blue: 1.0, alpha: 1.0)
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: KeyboardDoneResponder.shared,
            action: #selector(KeyboardDoneResponder.doneTapped)
        )
        toolbar.items = [flexSpace, done]
        return toolbar
    }
}

private final class KeyboardDoneResponder: NSObject {
    static let shared = KeyboardDoneResponder()

    @objc func doneTapped() {
        KeyboardDismiss.dismiss()
    }
}

private struct KeyboardDoneAccessoryAnchor: UIViewRepresentable {
    func makeUIView(context: Context) -> AnchorView {
        AnchorView()
    }

    func updateUIView(_ uiView: AnchorView, context: Context) {
        uiView.attachIfNeeded()
    }

    final class AnchorView: UIView {
        private weak var attachedInput: UIView?

        override func didMoveToWindow() {
            super.didMoveToWindow()
            attachIfNeeded()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            attachIfNeeded()
        }

        func attachIfNeeded() {
            guard window != nil else { return }
            guard let input = findTextInput() else { return }

            if attachedInput !== input {
                attachedInput = input
            }

            let toolbar = KeyboardInputAccessory.makeToolbar()

            if let textField = input as? UITextField {
                if textField.inputAccessoryView == nil {
                    textField.inputAccessoryView = toolbar
                }
            } else if let textView = input as? UITextView {
                if textView.inputAccessoryView == nil {
                    textView.inputAccessoryView = toolbar
                }
            }
        }

        private func findTextInput() -> UIView? {
            var candidate: UIView? = self
            while let view = candidate {
                if let found = searchTextInput(in: view) {
                    return found
                }
                candidate = view.superview
            }
            return nil
        }

        private func searchTextInput(in view: UIView) -> UIView? {
            if view is UITextField || view is UITextView {
                return view
            }
            for subview in view.subviews {
                if let found = searchTextInput(in: subview) {
                    return found
                }
            }
            return nil
        }
    }
}

extension View {
    func keyboardDoneAccessory() -> some View {
        background {
            KeyboardDoneAccessoryAnchor()
                .frame(width: 1, height: 1)
                .opacity(0)
                .allowsHitTesting(false)
        }
    }
}
