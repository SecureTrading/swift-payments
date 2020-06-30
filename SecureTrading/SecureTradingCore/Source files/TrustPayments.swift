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
    /// Accepts Locale instead of supported language Enum
    /// that way we can support unsupported language :)
    /// - Parameters:
    ///   - locale: Locale used to determine correct translations, if not set, a Locale.current value is used instead
    ///   - translationsForOverride: A dictionary of custom translations, overrides default values
    ///   - refer to LocalizableKeys for possible keys
    public func configure(locale: Locale = Locale.current, translationsForOverride: [Locale: [String: String]]?) {
        let resolvedLocale = resolveLocaleIdentifier(locale: locale)
        localizable = Localizable(locale: resolvedLocale)
        if let customTranslations = translationsForOverride {
            localizable?.overrideLocalizedKeys(with: customTranslations)
        }
    }

    /// Configures global settings
    /// - Parameters:
    ///   - locale: Locale used to determine correct translations, if not set, a Locale.current value is used instead
    ///   - customTranslations: A dictionary of custom translations, overrides default values
    ///   - refer to LocalizableKeysObjc for possible keys
    @objc public func configure(locale: Locale = Locale.current, customTranslations: [NSLocale: [NSNumber: String]]) {
        // check for supported keys
        localizable = Localizable(locale: locale)
        var customTranslationKeys: [Locale: [String: String]] = [:]
        for locale in customTranslations {
            var translationForLocale: [String: String] = [:]
            for translation in locale.value {
                guard let transKey = LocalizableKeysObjc(rawValue: translation.key.intValue)?.code else { continue }
                translationForLocale[transKey] = translation.value
            }
            customTranslationKeys[locale.key as Locale] = translationForLocale
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

    // MARK: - Helper methods
    /// Language code in given Locale is based on supported localizations by the main application
    /// in the case of missing Apple's way localized files, en is selected as default
    /// This method resolve locale identifier based on prefered language and region code
    /// - Parameter locale: Locale for which translations should be resolved
    /// - Returns: Locale made of prefered language and region
    private func resolveLocaleIdentifier(locale: Locale) -> Locale {
        guard let preferedLanguageCode = Locale.preferredLanguages.first?.components(separatedBy: "-").first else { return locale }
        guard let regionCode = locale.regionCode else { return locale }
        return Locale(identifier: preferedLanguageCode + "_" + regionCode)
    }

}
