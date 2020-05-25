//
//  CardNumber.swift
//  SecureTradingUI
//

import Foundation

public struct CardNumber: RawRepresentable {
    public typealias RawValue = String

    public let rawValue: String

    public var length: Int {
        return rawValue.count
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension CardNumber: CustomStringConvertible {

    public var description: String {
        return rawValue
    }

}
