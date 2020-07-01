//
//  TrustPayments.swift
//  SecureTradingCore
//

import Foundation
import TrustKit

/// SDK Initialization singleton class, used for global settings, like Locale, custom translation
@objc public final class TrustPayments: NSObject {
    /// Use to set global values
    @objc public static let instance: TrustPayments = TrustPayments()
    private override init() {
        // todo - set backup pins
        let trustKitConfig = [
            kTSKSwizzleNetworkDelegates: false,
            kTSKPinnedDomains: [
                GatewayType.eu.host: [
                    kTSKEnforcePinning: true,
                    kTSKIncludeSubdomains: true,
                    kTSKPublicKeyHashes: [
                        "kCv4KV+TUcfQ7XFk1Hk4oF2JlFRk9fObpVuZCKCZ/mk=",
                        "kCv4KV+TUcfQ7XFk1Hk4oF2JlFRk9fObpVuZCKCZ/mP=" // todo update
                    ]
                ],
                GatewayType.euBackup.host: [
                    kTSKEnforcePinning: true,
                    kTSKIncludeSubdomains: true,
                    kTSKPublicKeyHashes: [
                        "ZUx6EfJmVvDvoioQBPfjlWssKuu4S4Wkn8KOXQEeQSo=",
                        "ZUx6EfJmVvDvoioQBPfjlWssKuu4S4Wkn8KOXQEeQSG=" // todo update
                    ]
                ],
                GatewayType.us.host: [
                    kTSKEnforcePinning: true,
                    kTSKIncludeSubdomains: true,
                    kTSKPublicKeyHashes: [
                        "3yBX4bueFPIjR7Ek9Wkf1WQsUA91ITX3okf2IMkyBGc=",
                        "3yBX4bueFPIjR7Ek9Wkf1WQsUA91ITX3okf2IMkyBGF=" // todo update
                    ]
                ]
            ]
        ] as [String: Any]

        TrustKit.initSharedInstance(withConfiguration: trustKitConfig)
    }

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
}
