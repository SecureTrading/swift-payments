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
    
    static var domain: String {
        return "com.securetrading.SecureTradingCore"
    }
}
