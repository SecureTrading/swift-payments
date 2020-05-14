//
//  NSError.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation

extension NSError: HumanReadableStringConvertible {

    /// - SeeAlso: HumanReadableStringConvertible.humanReadableDescription
    internal var humanReadableDescription: String {
        return "\(localizedDescription) (\(code))"
    }

}
