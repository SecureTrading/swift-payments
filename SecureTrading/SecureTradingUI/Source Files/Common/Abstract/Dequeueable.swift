//
//  Dequeueable.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
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
