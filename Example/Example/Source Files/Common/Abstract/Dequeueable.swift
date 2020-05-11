//
//  Dequeueable.swift
//  SecureTradingUI
//

import Foundation

protocol Dequeueable {
    static var defaultReuseIdentifier: String { get }
}

extension Dequeueable {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
