//
//  JWTBodyResponse.swift
//  SecureTradingCore
//

struct JWTBodyPayload: Decodable {
    // MARK: Properties

    let responses: [JWTResponseObject]
}

private extension JWTBodyPayload {
    enum CodingKeys: String, CodingKey {
        case responses = "response"
    }
}

struct JWTBodyResponse: APIResponse {
    // MARK: Properties

    // array of multiple responses is returned in the case of multiple type descriptions request
    // for instance account check and auth will result in 2 response objects
    let responses: [JWTResponseObject]
  
    // MARK: Initialization

    /// - SeeAlso: Swift.Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let payload = try container.decode(JWTBodyPayload.self, forKey: .payload)
        responses = payload.responses
    }
}

private extension JWTBodyResponse {
    enum CodingKeys: String, CodingKey {
        case payload
    }
}
