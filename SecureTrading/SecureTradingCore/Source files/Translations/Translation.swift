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

final class Translations: NSObject {
    private var currentTranslations: [String: String] = [:]

    convenience override init() {
        self.init(locale: Locale.current)
    }

    init(locale: Locale) {
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

    func translation<T: TranslationKey>(for key: T) -> String {
        let translationKey = key.stringKey
        return currentTranslations[translationKey] ?? "No localized description for: \(translationKey)"
    }
    func overrideTranslations<T: TranslationKey>(with customKeys: [T: String]) {
        for customKey in customKeys {
            currentTranslations[customKey.key.stringKey] = customKey.value
        }
    }

    private func translationFileURL(identifier: String) -> URL {
        guard let path = Bundle(for: Translations.self).path(forResource: identifier, ofType: "json"),
            let url = URL(string: "file://" + path) else {
                fatalError("Missing translation file for locale: \(identifier)")
        }
        return url
    }
}

public protocol TranslationKey {
//    var stringKey: String { get }
}
public extension TranslationKey {
    var stringKey: String {
        return String(describing: "\(type(of: self)).\(self)")
    }
}
public struct TranslationsKeys {
    public enum PayButton: Int, TranslationKey {
        case title
    }
}

@objc public final class TrustPayments: NSObject {
    public static let instance: TrustPayments = TrustPayments()
    private var translations: Translations?

    public func configure<Key: TranslationKey>(locale: Locale, customTranslations: [Key: String]?) {
        translations = Translations(locale: locale)
        if let customTranslations = customTranslations {
            translations?.overrideTranslations(with: customTranslations)
        }
    }

    public static func translation<Key: TranslationKey>(for key: Key) -> String {
        if TrustPayments.instance.translations == nil {
            TrustPayments.instance.translations = Translations()
        }
        return TrustPayments.instance.translations!.translation(for: key)
    }

}
