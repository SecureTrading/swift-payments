//
//  NSError.swift
//  SecureTradingCore
//

import Foundation

extension NSError: HumanReadableStringConvertible {

    /// - SeeAlso: HumanReadableStringConvertible.humanReadableDescription
    internal var humanReadableDescription: String {
        return "\(localizedDescription) (\(code))"
    }

}
