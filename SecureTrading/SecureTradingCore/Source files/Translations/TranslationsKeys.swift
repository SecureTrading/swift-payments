//
//  TranslationsKeys.swift
//  SecureTradingCore
//

import Foundation

public protocol TranslationKey {}
public extension TranslationKey {
    /// Returns String representing TranslationsKeys as a String
    /// TranslationsKeys.PayButton.title -> "PayButton.title"
    var stringKey: String {
        return String(describing: "\(type(of: self)).\(self)")
    }

    /// Used to shorten slightly notation
    /// TrustPayments.translation(for: TranslationsKeys.Navigation.back) -> TranslationsKeys.Navigation.back.localizedString
    var localizedString: String? {
        TrustPayments.translation(for: self)
    }
}

/// Possible translation keys to use or override
public enum TranslationsKeys {
    // MARK: Pay Button
    public enum PayButton: TranslationKey {
        case title
    }

    // MARK: Navigation
    public enum Navigation: TranslationKey {
        case back
    }

    // MARK: DropIn View Controller
    public enum DropInViewController: TranslationKey {
        case title
        case successfulPayment
        case cardinalAuthenticationError
    }
}

/// Objc workaround for Translations Keys
@objc public enum TranslationsKeysObjc: Int {
    //swiftlint:disable identifier_name
    // underscores used for clarity: _payButton_title -> TranslationsKeysObjc_payButton_title
    case _payButton_title = 0

    case _navigation_back

    /// Used for mapping objc enum into TranslationsKeys
    var code: String {
        switch self {
        case ._payButton_title: return TranslationsKeys.PayButton.title.stringKey
        case ._navigation_back: return TranslationsKeys.Navigation.back.stringKey
        }
    }
}
