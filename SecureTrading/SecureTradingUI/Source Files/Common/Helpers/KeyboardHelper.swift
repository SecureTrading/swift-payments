//
//  KeyboardHelper.swift
//  SecureTradingUI
//

import UIKit

protocol KeyboardHelperDelegate: class {
    func keyboardChanged(size: CGSize, animationDuration: TimeInterval, isHidden: Bool)
}

/// Helper class for notifyinga bout Keyboard appearance
class KeyboardHelper {
    private weak var delegate: KeyboardHelperDelegate?

    init() { }

    func register(target: KeyboardHelperDelegate) {
        self.delegate = target

        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHelper.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardHelper.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unregister() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        let duration: TimeInterval = TimeInterval(exactly: keyboardAnimationDuration) ?? 0
        self.delegate?.keyboardChanged(size: keyboardFrame.size, animationDuration: duration, isHidden: false)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
        let duration: TimeInterval = TimeInterval(exactly: keyboardAnimationDuration ?? 0) ?? 0
        self.delegate?.keyboardChanged(size: CGSize.zero, animationDuration: duration, isHidden: true)
    }
}
