//
//  Expiry.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 03/06/2020.
//

import Foundation

@objc public class ExpiryDate: NSObject, RawRepresentable {
    public typealias RawValue = String

    public let rawValue: String

    public var length: Int {
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
