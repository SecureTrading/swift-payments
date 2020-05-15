//
//  DecodeError.swift
//  SecureTradingCore
//

import Foundation

public enum DecodeError: Error {
    case invalidBase64Url
    case invalidJSON
    case invalidPartCount
}
