//
//  ResponseObject.swift
//  SecureTradingCore
//

import Foundation

/// Response object that holds received error code and message
struct ResponseObject: Decodable {
    let errorCode: Int
    let errorMessage: String
    
    /// - SeeAlso: Swift.Decodable
    init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: ResponseObjectCodingKeys.self)
          let errorCodeString = try container.decode(String.self, forKey: .errorCode)
          errorCode = Int(errorCodeString) ?? -1
          errorMessage = try container.decode(String.self, forKey: .errorMessage)
      }
}
private extension ResponseObject {
    enum ResponseObjectCodingKeys: String, CodingKey {
        case errorCode = "errorcode"
        case errorMessage = "errormessage"
    }
}
