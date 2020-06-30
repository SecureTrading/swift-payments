//
//  LocalizableKeys.swift
//  SecureTradingCore
//

import Foundation

public protocol LocalizableKey {}
public extension LocalizableKey {
    /// Returns String representing LocalizableKeys as a String
    /// LocalizableKeys.PayButton.title -> "PayButton.title"
    var key: String {
        return String(describing: "\(type(of: self)).\(self)")
    }

    /// Used to shorten slightly notation
    /// TrustPayments.translation(for: LocalizableKeys.Navigation.back) -> LocalizableKeys.Navigation.back.localizedString
    var localizedString: String? {
        TrustPayments.translation(for: self)
    }

    var localizedStringOrEmpty: String {
        TrustPayments.translation(for: self) ?? ""
    }
}

/// Possible translation keys to use or override
public enum LocalizableKeys {
    // MARK: Pay Button
    public enum PayButton: LocalizableKey {
        case title
    }

    // MARK: Navigation
    public enum Navigation: LocalizableKey {
        case back
    }

    // MARK: DropIn View Controller
    public enum DropInViewController: LocalizableKey {
        case title
        case successfulPayment
        case cardinalAuthenticationError
    }

    // MARK: CardNumberInputView
    public enum CardNumberInputView: LocalizableKey {
        case title
        case placeholder
        case error
        case emptyError
    }

    // MARK: CvcInputView
    public enum CvcInputView: LocalizableKey {
        case title
        case placeholder3
        case placeholder4
        case placeholderPiba
        case error
        case emptyError
    }

    // MARK: ExpiryDateInputView
    public enum ExpiryDateInputView: LocalizableKey {
        case title
        case placeholder
        case error
        case emptyError
    }

    // MARK: AddCardButton
    public enum AddCardButton: LocalizableKey {
        case title
    }

    // MARK: Alerts
    public enum Alerts: LocalizableKey {
        case processing
    }
}

/// Objc workaround for LocalizableKeys
@objc public enum LocalizableKeysObjc: Int {
    //swiftlint:disable identifier_name
    // underscores used for clarity: _payButton_title -> LocalizableKeysObjc_payButton_title
    case _payButton_title = 0

    case _navigation_back

    case _dropInViewController_title
    case _dropInViewController_successfulPayment
    case _dropInViewController_cardinalAuthenticationError

    case _cardNumberInputView_title
    case _cardNumberInputView_placeholder
    case _cardNumberInputView_error
    case _cardNumberInputView_emptyError

    case _cvcInputView_title
    case _cvcInputView_placeholder3
    case _cvcInputView_placeholder4
    case _cvcInputView_placeholderPiba
    case _cvcInputView_error
    case _cvcInputView_emptyError

    case _expiryDateInputView_title
    case _expiryDateInputView_placeholder
    case _expiryDateInputView_error
    case _expiryDateInputView_emptyError

    case _addCardButton_title

    case _alerts_processing

    /// Used for mapping objc enum into TranslationsKeys
    var code: String {
        switch self {
        case ._payButton_title: return LocalizableKeys.PayButton.title.key

        case ._navigation_back: return LocalizableKeys.Navigation.back.key

        case ._dropInViewController_title: return LocalizableKeys.DropInViewController.title.key
        case ._dropInViewController_successfulPayment: return LocalizableKeys.DropInViewController.successfulPayment.key
        case ._dropInViewController_cardinalAuthenticationError: return LocalizableKeys.DropInViewController.cardinalAuthenticationError.key

        case ._cardNumberInputView_title: return LocalizableKeys.CardNumberInputView.title.key
        case ._cardNumberInputView_placeholder: return LocalizableKeys.CardNumberInputView.placeholder.key
        case ._cardNumberInputView_error: return LocalizableKeys.CardNumberInputView.error.key
        case ._cardNumberInputView_emptyError: return LocalizableKeys.CardNumberInputView.emptyError.key

        case ._cvcInputView_title: return LocalizableKeys.CvcInputView.title.key
        case ._cvcInputView_placeholder3: return LocalizableKeys.CvcInputView.placeholder3.key
        case ._cvcInputView_placeholder4: return LocalizableKeys.CvcInputView.placeholder4.key
        case ._cvcInputView_placeholderPiba: return LocalizableKeys.CvcInputView.placeholderPiba.key
        case ._cvcInputView_error: return LocalizableKeys.CvcInputView.error.key
        case ._cvcInputView_emptyError: return LocalizableKeys.CvcInputView.emptyError.key

        case ._expiryDateInputView_title: return LocalizableKeys.ExpiryDateInputView.title.key
        case ._expiryDateInputView_placeholder: return LocalizableKeys.ExpiryDateInputView.placeholder.key
        case ._expiryDateInputView_error: return LocalizableKeys.ExpiryDateInputView.error.key
        case ._expiryDateInputView_emptyError: return LocalizableKeys.ExpiryDateInputView.emptyError.key

        case ._addCardButton_title: return LocalizableKeys.AddCardButton.title.key

        case ._alerts_processing: return LocalizableKeys.Alerts.processing.key
        }
    }
}
