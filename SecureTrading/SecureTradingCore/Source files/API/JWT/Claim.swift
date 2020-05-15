//
//  Claim.swift
//  SecureTradingCore
//

import Foundation

public struct Claim {
    /// raw value of the claim
    let value: Any?

    /// original claim value
    public var rawValue: Any? {
        return self.value
    }

    /// value of the claim as `String`
    public var string: String? {
        return self.value as? String
    }

    /// value of the claim as `Int`
    public var integer: Int? {
        guard let integer = self.value as? Int else {
            if let string = self.string {
                return Int(string)
            } else if let double = self.value as? Double {
                return Int(double)
            }
            return nil
        }
        return integer
    }

    /// value of the claim as `Double`
    public var double: Double? {
        guard let double = self.value as? Double else {
            if let string = self.string {
                return Double(string)
            }
            return nil
        }
        return double
    }

    /// value of the claim as `NSDate`
    public var date: Date? {
        guard let timestamp: TimeInterval = self.double else { return nil }
        return Date(timeIntervalSince1970: timestamp)
    }

    /// value of the claim as `[String]`
    public var array: [String]? {
        if let array = value as? [String] {
            return array
        }
        if let value = self.string {
            return [value]
        }
        return nil
    }
}
