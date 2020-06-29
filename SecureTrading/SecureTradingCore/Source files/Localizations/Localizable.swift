//
//  Localizable.swift
//  SecureTradingCore
//

import Foundation

// Stores current translation strings based on locale or user preference
final class Localizable: NSObject {
    private var currentTranslations: [String: String] = [:]

    // MARK: - Initialization
    /// Initialize with current locale
    convenience override init() {
        self.init(locale: Locale.current)
    }

    /// Initialize with given locale
    /// - Parameter locale: Locale for which translations should be loaded
    init(locale: Locale) {
        super.init()
        let translationFile = self.translationFileURL(identifier: Localizable.Language.supportedLanguage(for: locale).rawValue)

        do {
            // Loads translations from json files
            let fileData = try Data(contentsOf: translationFile)
            let translationJSON = try JSONSerialization.jsonObject(with: fileData, options: JSONSerialization.ReadingOptions(rawValue: 0))
            guard let translations = translationJSON as? [String: String] else {
                fatalError("Incorrect format of translation file for: \(locale.identifier)")
            }
            currentTranslations = translations
        } catch {
            fatalError("Missing translation file, cannot proceed: \(error.localizedDescription)")
        }
    }

    /// Returns localized string for given key
    /// - Parameter key: Key for which localized string should be returned
    /// - Returns: Localized string or nil
    func localizedString<T: LocalizableKey>(for key: T) -> String? {
        let translationKey = key.key
        return currentTranslations[translationKey]
    }

    /// Overrides default translation values with provided values
    /// - Parameter customKeys: Dictionary containing translation keys to override with their values
    @objc func overrideLocalizedKeys(with customKeys: [String: String]) {
        for customKey in customKeys {
            currentTranslations[customKey.key] = customKey.value
        }
    }

    /// Return translation file url for given locale identifier
    /// - Parameter identifier: iso language identifier, eg: en_US
    /// - Returns: URL for translation file
    private func translationFileURL(identifier: String) -> URL {
        guard let path = Bundle(for: Localizable.self).path(forResource: identifier, ofType: "json") else {
                fatalError("Missing translation file for locale: \(identifier)")
        }
        return URL(fileURLWithPath: path)
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

        static func supportedLanguage(for locale: Locale) -> Language {
            return Language(rawValue: locale.identifier) ?? Language.en_GB
        }
    }
}
