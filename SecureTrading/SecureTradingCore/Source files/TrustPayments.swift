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

    /// Reference to Translations object
    private var translations: Translations?

    /// Configures global settings
    /// - Parameters:
    ///   - locale: Locale used to determine correct translations, if not set, a Locale.current value is used instead
    ///   - customTranslations: A dictionary of custom translations, overrides default values
    ///   - refer to TranslationsKeys for possible keys
    public func configure<Key: TranslationKey>(locale: Locale = Locale.current, customTranslations: [Key: String]?) {
        translations = Translations(locale: locale)
        if let customTranslations = customTranslations {
            let convertedTranslations = Dictionary(uniqueKeysWithValues: customTranslations.map { ($0.key.stringKey, $0.value)})
            translations?.overrideTranslations(with: convertedTranslations)
        }
    }

    /// Configures global settings
    /// - Parameters:
    ///   - locale: Locale used to determine correct translations, if not set, a Locale.current value is used instead
    ///   - customTranslations: A dictionary of custom translations, overrides default values
    ///   - refer to TranslationsKeysObjc for possible keys
    @objc public func configure(locale: Locale = Locale.current, customTranslations: [NSNumber: String]) {
        // check for supported keys
        translations = Translations(locale: locale)
        var customTranslationKeys: [String: String] = [:]
        for translation in customTranslations {
            guard let transKey = TranslationsKeysObjc(rawValue: translation.key.intValue)?.code else { continue }
            customTranslationKeys[transKey] = translation.value
        }
        translations?.overrideTranslations(with: customTranslationKeys)
    }

    /// Returns translation string for given locale
    /// - Parameter key: Translation key for which correct translated string should be returned
    /// - Returns: Found translated string or nil otherwise
    public static func translation<Key: TranslationKey>(for key: Key) -> String? {
        if TrustPayments.instance.translations == nil {
            TrustPayments.instance.translations = Translations()
        }
        return TrustPayments.instance.translations!.translation(for: key)
    }

}
