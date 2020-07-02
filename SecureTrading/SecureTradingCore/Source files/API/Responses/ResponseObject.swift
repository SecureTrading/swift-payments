//
//  ResponseObject.swift
//  SecureTradingCore
//

import Foundation

/// Response object that holds received error code and message
struct ResponseObject: Decodable {
    let errorCode: Int
    let errorMessage: String
    let errorData: String?

    // returns localized error from gateway
    var localizedError: String? {
        if let errorData = errorData?.first {
            return errorMessage + ": " + "\(errorData)"
        }
        return nil
    }

    /// - SeeAlso: Swift.Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseObjectCodingKeys.self)
        let errorCodeString = try container.decode(String.self, forKey: .errorCode)
        self.errorCode = Int(errorCodeString) ?? -1
        self.errorMessage = try container.decode(String.self, forKey: .errorMessage)
        self.errorData = try container.decodeIfPresent([String].self, forKey: .errorData)?.first
    }
}
private extension ResponseObject {
    enum ResponseObjectCodingKeys: String, CodingKey {
        case errorCode = "errorcode"
        case errorMessage = "errormessage"
        case errorData = "errordata"
    }
}
