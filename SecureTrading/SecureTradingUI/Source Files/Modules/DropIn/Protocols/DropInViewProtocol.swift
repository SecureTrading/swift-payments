//
//  DropInViewProtocol.swift
//  SecureTradingUI
//

import UIKit

@objc public protocol DropInViewProtocol: ViewProtocol {

    @objc var isFormValid: Bool { get }

    @objc var payButtonTappedClosure: (() -> Void)? { get set }

    @objc var cardNumberInput: CardNumberInputView { get }

    @objc var expiryDateInput: ExpiryDateInputView { get }

    @objc var cvcInput: CvcInputView { get }

    @objc var payButton: PayButton { get }
}
