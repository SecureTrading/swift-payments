//
//  ResponseError.swift
//  SecureTradingCore
//

import Foundation

/// Parses response with error in plain JSON format
struct ResponseError: APIResponse {
    /// received response
    let response: ResponseObject
    
    /// error from received response
    var error: Error {
        NSError(domain: NSError.domain, code: response.errorCode, userInfo: [NSLocalizedDescriptionKey: response.errorMessage])
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseErrorCodingKey.self)
        let responses = try container.decode([ResponseObject].self, forKey: .response)
        
        if let response = responses.first {
            self.response = response
        } else {
            let errorContext = DecodingError.Context.init(codingPath: [ResponseErrorCodingKey.response], debugDescription: "Missing response data")
            throw DecodingError.valueNotFound(ResponseObject.self, errorContext)
        }
    }
}

private extension ResponseError {
    enum ResponseErrorCodingKey: CodingKey {
        case response
    }
}
