//
//  CardNumber.swift
//  SecureTradingUI
//

import Foundation

@objc public class CardNumber: NSObject, RawRepresentable {
    public typealias RawValue = String

    public let rawValue: String

    public var length: Int {
        return rawValue.count
    }

    @objc required public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension CardNumber {

    public override var description: String {
        return rawValue
    }

}
