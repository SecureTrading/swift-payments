//
//  CVC.swift
//  SecureTradingUI
//

import Foundation

@objc public class CVC: NSObject, RawRepresentable {
    public typealias RawValue = String

    @objc public let rawValue: String

    @objc public var length: Int {
        return rawValue.count
    }

    @objc public required init(rawValue: String) {
        self.rawValue = rawValue
    }

    @objc public var intValue: Int {
        return Int(rawValue) ?? -1
    }
}

extension CVC {
    public override var description: String {
        return rawValue
    }
}
