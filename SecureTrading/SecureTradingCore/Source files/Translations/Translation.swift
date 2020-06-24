//
//  Translation.swift
//  SecureTradingCore
//

import Foundation
// Load translation file based on locale or user preference

extension Translations {
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

@objc public class Translations: NSObject {
    private var currentTranslations: [String: String] = [:]

    @objc public convenience override init() {
        self.init(locale: Locale.current)
    }

    @objc public init(locale: Locale) {
        super.init()
        let translationFile = self.translationFileURL(identifier: Translations.Language.supportedLanguage(for: locale).rawValue)

        do {
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

    public func translation<T: TranslationKey>(for key: T) -> String {
        let translationKey = String(describing: "\(type(of: key)).\(key)")
        return currentTranslations[translationKey] ?? "No localized description for: \(translationKey)"
    }

    private func translationFileURL(identifier: String) -> URL {
        guard let path = Bundle(for: Translations.self).path(forResource: identifier, ofType: "json"),
            let url = URL(string: "file://" + path) else {
                fatalError("Missing translation file for locale: \(identifier)")
        }
        return url
    }
}

public protocol TranslationKey {}

public extension Translations {
    enum PayButton: Int, TranslationKey {
        case title
    }
}
