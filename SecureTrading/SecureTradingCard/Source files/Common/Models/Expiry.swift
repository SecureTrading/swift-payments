//
//  Expiry.swift
//  SecureTradingUI
//

import Foundation

@objc public class ExpiryDate: NSObject, RawRepresentable {
    public typealias RawValue = String

    @objc public let rawValue: String

    @objc public var length: Int {
        return rawValue.count
    }

    @objc public required init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension ExpiryDate {
    public override var description: String {
        return rawValue
    }
}
