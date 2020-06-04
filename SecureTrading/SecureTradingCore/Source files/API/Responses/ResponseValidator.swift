//
//  ResponseValidator.swift
//  SecureTradingCore
//

import Foundation

class ResponseValidator {
    static func validate<Request: APIRequest, Response: APIResponse>(request: Request, response: Response) throws {
        // check for known errors
        // then check for data integrity
        if let response = response as? GeneralResponse {
            if response.jwtDecoded.hasErrors {
                // incorrect request: invalid pan, security code, jwt
                if let firstResponseWithError = response.jwtDecoded.jwtBodyResponse.responses
                    .first(where: { $0.responseErrorCode != ResponseErrorCode.successful }) {
                    throw APIClientError.responseValidationError(.invalidField(code: firstResponseWithError.errorDetails))
                }
            } else if request.isValidAgainstResponse(response) {
                // check if request's type description matches response's type description
                throw APIClientError.responseValidationError(.mismatchedDescriptionTypes)
            }
        }
    }
}
