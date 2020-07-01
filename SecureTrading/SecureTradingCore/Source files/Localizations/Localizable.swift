//
//  Localizable.swift
//  SecureTradingCore
//

import Foundation

// Stores current translation strings based on locale or user preference
final class Localizable: NSObject {

    /// Current locale set o initialization
    private let currentLocale: Locale

    /// Stores localized strings for current locale
    private var currentTranslations: [String: String] = [:]

    /// Stores localized strings provided by merchant to override default values
    private var customTranslations: [Locale: [String: String]] = [:]

    /// Initialize with given locale
    /// - Parameter locale: Locale for which translations should be loaded
    init(locale: Locale = Locale.current) {
        currentLocale = Localizable.resolveLocaleIdentifier(locale: locale)
        super.init()
        let translationFile = self.translationFileURL(identifier: Localizable.Language.supportedLanguage(for: currentLocale).rawValue)
        do {
            // Loads translations from json files
            let fileData = try Data(contentsOf: translationFile)
            let translationJSON = try JSONSerialization.jsonObject(with: fileData, options: JSONSerialization.ReadingOptions(rawValue: 0))
            guard let translations = translationJSON as? [String: String] else {
                fatalError("Incorrect format of translation file for: \(currentLocale.identifier)")
            }
            currentTranslations = translations
        } catch {
            fatalError("Missing translation file, cannot proceed: \(error.localizedDescription)")
        }
    }

    /// Returns localized string for given key from custom translations
    /// If missing, then returns localized string for default translations values
    /// - Parameter key: Key for which localized string should be returned
    /// - Returns: Localized string or nil
    func localizedString<T: LocalizableKey>(for key: T) -> String? {
        if let customLocalizedString = customTranslations[currentLocale]?[key.key] {
            return customLocalizedString
        }
        return currentTranslations[key.key]
    }

    /// Overrides default translation values with provided values
    /// - Parameter customKeys: Dictionary containing translation keys to override with their values
    @objc func overrideLocalizedKeys(with customKeys: [Locale: [String: String]]) {
        customTranslations = customKeys
    }

    // MARK: - Helper methods

    /// Return translation file url for given locale identifier
    /// - Parameter identifier: iso language identifier, eg: en_US
    /// - Returns: URL for translation file
    private func translationFileURL(identifier: String) -> URL {
        guard let path = Bundle(for: Localizable.self).path(forResource: identifier, ofType: "json") else {
                fatalError("Missing translation file for locale: \(identifier)")
        }
        return URL(fileURLWithPath: path)
    }

    /// Language code in given Locale is based on supported localizations by the main application
    /// in the case of missing Apple's way localized files, en is selected as default
    /// This method resolve locale identifier based on prefered language and region code
    /// - Parameter locale: Locale for which translations should be resolved
    /// - Returns: Locale made of prefered language and region
    private static func resolveLocaleIdentifier(locale: Locale) -> Locale {
        // if locale is supported, return
        if locale.isSupported {
            return locale
        }

        // make locale identifier from prefered language and region
        guard let preferedLanguageCode = Locale.preferredLanguages.first?.components(separatedBy: "-").first else { return locale }
        guard let regionCode = locale.regionCode else { return locale }
        let resolvedLocale = Locale(identifier: preferedLanguageCode + "_" + regionCode)

        // if locale after modification is supported, return
        if resolvedLocale.isSupported {
            return resolvedLocale
        }

        // otherwise could not resolve locale and returns default one
        return Locale(identifier: Localizable.Language.default.rawValue)
    }
}

private extension Locale {
    /// Checks if given locale is supported by SDK
    var isSupported: Bool {
        return Localizable.Language.supportedLanguage(for: self).rawValue == self.identifier
    }
}

/// Supported languages
/// en_GB is used as a default if supported language cannot be determined based on given locale
extension Localizable {
    //swiftlint:disable identifier_name
    enum Language: String {
        case cy_GB
        case da_DK
        case de_DE
        case en_GB
        case en_US
        case es_ES
        case fr_FR
        case nl_NL
        case no_NO
        case sv_SE

        static var `default`: Language {
            return .en_GB
        }

        static func supportedLanguage(for locale: Locale) -> Language {
            return Language(rawValue: locale.identifier) ?? Language.en_GB
        }
    }
}
