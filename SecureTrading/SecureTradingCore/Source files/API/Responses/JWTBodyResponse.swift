//
//  JWTBodyResponse.swift
//  SecureTradingCore
//

struct JWTBodyPayload: Codable {
    let responses: [JWTResponseObject]
}

private extension JWTBodyPayload {
    enum CodingKeys: String, CodingKey {
        case responses = "response"
    }
}

struct JWTBodyResponse: APIResponse {

    // MARK: Properties

    let responses: [JWTResponseObject]

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
