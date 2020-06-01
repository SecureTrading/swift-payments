//
//  BackwardTextfield.swift
//  SecureTradingUI
//

import UIKit

class BackwardTextField: UITextField {
    open override var placeholder: String? {
        didSet {
            setNeedsDisplay()
        }
    }

    open var deleteLastCharCallback: ((UITextField) -> Void)?

    open override var text: String? {
        didSet {
            if (text ?? .empty).isEmpty {
                deleteLastCharCallback?(self)
            } else if text == UITextField.emptyCharacter {
                drawPlaceholder(in: textInputView.bounds)
            }
            setNeedsDisplay()
        }
    }

    open override func draw(_ rect: CGRect) {
        if text == .empty || text == UITextField.emptyCharacter {
            super.drawPlaceholder(in: rect)
        } else {
            super.draw(rect)
        }
    }

    open override func drawPlaceholder(in rect: CGRect) {}
}
