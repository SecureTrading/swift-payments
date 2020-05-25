//
//  CardNumberInputVIew.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 25/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

@objc public final class CardNumberInputView: SecureFormInputView {
    /**
     The string that is used to separate different groups in a card number.
     */
    public var cardNumberSeparator: String = "-"
}

// MARK: TextField delegate

extension CardNumberInputView {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Current text in text field, formatted and unformatted:
              let textFieldTextFormatted = NSString(string: textField.text ?? "")
              // Text in text field after applying changes, formatted and unformatted:
              let newTextFormatted = textFieldTextFormatted.replacingCharacters(in: range, with: string)
        

        return false
    }

//    public override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
}
