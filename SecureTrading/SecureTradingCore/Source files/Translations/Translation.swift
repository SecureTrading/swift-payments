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
            return Language(rawValue: locale.identifier) ?? Language.en_US
        }
    }
}
@objc public class Translations: NSObject {
    private var currentTranslations: [String: String] = [:]

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

    private func translationFileURL(identifier: String) -> URL {
        print("id:\(identifier)")
        guard let path = Bundle(for: Translations.self).path(forResource: identifier, ofType: "json"),
            let url = URL(string: "file://" + path) else {
                fatalError("Missing translation file for locale: \(identifier)")
        }
        print(url)
        return url
    }
}
