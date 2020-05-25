//
//  String.swift
//  SecureTradingCard
//

import Foundation

extension String {
    /// Removes non digit characters
    var onlyDigits: String {
        return self.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
    }
}
