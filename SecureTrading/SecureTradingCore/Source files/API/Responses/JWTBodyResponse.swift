//
//  JWTBodyResponse.swift
//  SecureTradingCore
//

struct JWTBodyPayload: Decodable {
    // MARK: Properties

    let newJWT: String
    let responses: [JWTResponseObject]
}

private extension JWTBodyPayload {
    enum CodingKeys: String, CodingKey {
        case responses = "response"
        case newJWT = "jwt"
    }
}

struct JWTBodyResponse: APIResponse {
    // MARK: Properties

    //new JWT token to be swapped in the request sequence
    let newJWT: String

    // array of multiple responses is returned in the case of multiple type descriptions request
    // for instance account check and auth will result in 2 response objects
    let responses: [JWTResponseObject]

    // MARK: Initialization

    /// - SeeAlso: Swift.Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let payload = try container.decode(JWTBodyPayload.self, forKey: .payload)
        newJWT = payload.newJWT
        responses = payload.responses
    }
}

private extension JWTBodyResponse {
    enum CodingKeys: String, CodingKey {
        case payload
    }
}
