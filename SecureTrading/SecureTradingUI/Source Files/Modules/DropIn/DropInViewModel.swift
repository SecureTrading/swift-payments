//
//  DropInViewModel.swift
//  SecureTradingUI
//

import Foundation

final class DropInViewModel {

    @discardableResult
    func validateForm(view: DropInView) -> Bool {
        let cardNumberValidationResult = view.cardNumberInput.validate(silent: false)
        let expiryDateValidationResult = view.expiryDateInput.validate(silent: false)
        let cvcValidationResult = view.cvcInput.validate(silent: false)
        return cardNumberValidationResult && expiryDateValidationResult && cvcValidationResult
    }
}
