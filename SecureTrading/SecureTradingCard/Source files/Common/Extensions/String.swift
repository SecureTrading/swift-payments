//
//  String.swift
//  SecureTradingCard
//

import Foundation

extension String {
    public static let empty = ""
    public static let space = " "
}

extension String {
    /// Removes non digit characters
    var onlyDigits: String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
