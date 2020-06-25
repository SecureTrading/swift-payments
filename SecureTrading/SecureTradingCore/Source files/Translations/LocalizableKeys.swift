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
}

/// Objc workaround for LocalizableKeys
@objc public enum LocalizableKeysObjc: Int {
    //swiftlint:disable identifier_name
    // underscores used for clarity: _payButton_title -> LocalizableKeysObjc_payButton_title
    case _payButton_title = 0

    case _navigation_back

    /// Used for mapping objc enum into TranslationsKeys
    var code: String {
        switch self {
        case ._payButton_title: return LocalizableKeys.PayButton.title.key
        case ._navigation_back: return LocalizableKeys.Navigation.back.key
        }
    }
}
