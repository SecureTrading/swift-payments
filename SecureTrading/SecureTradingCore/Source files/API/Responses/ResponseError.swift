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
        var errorMessage = response.errorMessage
        if response.errorCode == ResponseErrorCode.fieldError.rawValue {
            // Other fields are not validated before Gateway and are handled by proper Response object
            switch response.errorData {
            case "jwt": errorMessage = APIResponseValidationError.invalidField(code: .invalidJWT).localizedDescription
            case "sitereference": errorMessage = APIResponseValidationError.invalidField(code: .invalidSiteReference).localizedDescription
            default: break
            }
        }
        return NSError(domain: NSError.domain, code: response.errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseErrorCodingKey.self)
        let responses = try container.decode([ResponseObject].self, forKey: .response)

        if let response = responses.first {
            self.response = response
        } else {
            let errorContext = DecodingError.Context.init(codingPath: [ResponseErrorCodingKey.response], debugDescription: LocalizableKeys.APIError.missingResponseData.localizedStringOrEmpty)
            throw DecodingError.valueNotFound(ResponseObject.self, errorContext)
        }
    }
}

private extension ResponseError {
    enum ResponseErrorCodingKey: CodingKey {
        case response
    }
}
