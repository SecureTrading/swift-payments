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
}

/// Possible translation keys to use or override
public enum TranslationsKeys {
    public enum PayButton: String, TranslationKey {
        case title
    }
}

/// Objc workaround for Translations Keys
@objc public enum TranslationsKeysObjc: Int {
    //swiftlint:disable identifier_name
    // underscores used for clarity: _payButton_title -> TranslationsKeysObjc_payButton_title
    case _payButton_title = 0

    /// Used for mapping objc enum into TranslationsKeys
    var code: String {
        switch self {
        case ._payButton_title: return "PayButton.title"
        }
    }
}
