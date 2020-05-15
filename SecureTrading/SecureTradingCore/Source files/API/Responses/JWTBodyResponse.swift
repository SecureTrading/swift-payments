//
//  JWTBodyResponse.swift
//  SecureTradingCore
//

struct JWTBodyResponse: APIResponse {
    // MARK: Properties

    let responses: [JWTResponseObject]
}

private extension JWTBodyResponse {
    enum CodingKeys: String, CodingKey {
        case responses = "response"
    }
}
