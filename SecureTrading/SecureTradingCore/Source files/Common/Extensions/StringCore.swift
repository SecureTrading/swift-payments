//
//  StringCore.swift
//  SecureTradingCore
//

import Foundation

extension String {
    public static let empty = ""
    public static let space = " "
}

extension String {
    /// Removes non digit characters
    public var onlyDigits: String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

extension String {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
