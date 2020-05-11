//
//  Localizable.swift
//  Example
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation

protocol Localized {}

extension Localized where Self: RawRepresentable, Self.RawValue == String {
    var text: String {
        let selfClassName = String(describing: type(of: self))
        return NSLocalizedString("\(selfClassName).\(rawValue)", value: "No localized string found", comment: "")
    }

    func localized(forLanguage language: String = Locale.preferredLanguages.first!.components(separatedBy: "-").first!) -> String {
        let selfClassName = String(describing: type(of: self))

        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            let basePath = Bundle.main.path(forResource: "en", ofType: "lproj")!

            return Bundle(path: basePath)!.localizedString(forKey: "\(selfClassName).\(rawValue)", value: "", table: nil)
        }

        return Bundle(path: path)!.localizedString(forKey: "\(selfClassName).\(rawValue)", value: "", table: nil)
    }
}

enum Localizable {}
