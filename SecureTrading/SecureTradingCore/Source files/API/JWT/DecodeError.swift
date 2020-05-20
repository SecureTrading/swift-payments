//
//  DecodeError.swift
//  SecureTradingCore
//

import Foundation

public enum DecodeError: Error {
    case invalidBase64Url
    case invalidJSON
    case invalidPartCount

//    var foundationError: NSError {
//        return NSError(domain: domain, code: errorCode, userInfo: [
//            NSLocalizedDescriptionKey : description
//        ])
//    }
}
