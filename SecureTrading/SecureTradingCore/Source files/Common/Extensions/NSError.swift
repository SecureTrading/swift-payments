//
//  NSError.swift
//  SecureTradingCore
//

import Foundation

extension NSError: HumanReadableStringConvertible {

    /// - SeeAlso: HumanReadableStringConvertible.humanReadableDescription
    public var humanReadableDescription: String {
        return "\(localizedDescription) (\(code))"
    }

}
