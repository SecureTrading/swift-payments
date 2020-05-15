//
//  DecodeError.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 15/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation

public enum DecodeError: Error {
    case invalidBase64Url
    case invalidJSON
    case invalidPartCount
}
