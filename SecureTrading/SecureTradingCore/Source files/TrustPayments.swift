//
//  TrustPayments.swift
//  SecureTradingCore
//

import Foundation

/// SDK Initialization singleton class, used for global settings, like Locale, custom translation
@objc public final class TrustPayments: NSObject {

    /// Use to set global values
    @objc public static let instance: TrustPayments = TrustPayments()
    private override init() { }

    /// Reference to Localizable object
    private var localizable: Localizable?

    /// Configures global settings
    /// - Parameters:
    ///   - locale: Locale used to determine correct translations, if not set, a Locale.current value is used instead
    ///   - translationsForOverride: A dictionary of custom translations, overrides default values
    ///   - refer to LocalizableKeys for possible keys
    public func configure(locale: Locale = Locale.current, translationsForOverride: [String: String]?) {
        localizable = Localizable(locale: locale)
        if let customTranslations = translationsForOverride {
            localizable?.overrideLocalizedKeys(with: customTranslations)
        }
    }

    /// Configures global settings
    /// - Parameters:
    ///   - locale: Locale used to determine correct translations, if not set, a Locale.current value is used instead
    ///   - customTranslations: A dictionary of custom translations, overrides default values
    ///   - refer to LocalizableKeysObjc for possible keys
    @objc public func configure(locale: Locale = Locale.current, customTranslations: [NSNumber: String]) {
        // check for supported keys
        localizable = Localizable(locale: locale)
        var customTranslationKeys: [String: String] = [:]
        for translation in customTranslations {
            guard let transKey = LocalizableKeysObjc(rawValue: translation.key.intValue)?.code else { continue }
            customTranslationKeys[transKey] = translation.value
        }
        localizable?.overrideLocalizedKeys(with: customTranslationKeys)
    }

    /// Returns translation string for given locale
    /// - Parameter key: Localizable key for which correct translated string should be returned
    /// - Returns: Found translated string or nil otherwise
    public static func translation<Key: LocalizableKey>(for key: Key) -> String? {
        if TrustPayments.instance.localizable == nil {
            TrustPayments.instance.localizable = Localizable()
        }
        return TrustPayments.instance.localizable!.localizedString(for: key)
    }

}
