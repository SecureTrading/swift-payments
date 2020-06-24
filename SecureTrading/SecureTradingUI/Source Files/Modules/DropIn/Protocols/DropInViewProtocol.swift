//
//  DropInViewProtocol.swift
//  SecureTradingUI
//

import UIKit

@objc public protocol DropInViewProtocol: ViewProtocol {

    @objc var isFormValid: Bool { get }

    // this closure should be triggered when the pay button is pressed
    @objc var payButtonTappedClosure: (() -> Void)? { get set }

    @objc var cardNumberInput: CardNumberInput { get }

    @objc var expiryDateInput: ExpiryDateInput { get }

    @objc var cvcInput: CvcInput { get }

    @objc var payButton: PayButtonProtocol { get }
}
