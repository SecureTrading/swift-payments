//
//  GeneralResponse.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation

struct GeneralResponse: APIResponse {
    // MARK: Properties

    let jwt: String
    let jwtDecoded: DecodedJWT?

    /// - SeeAlso: Swift.Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        jwt = try container.decode(String.self, forKey: .jwt)
        jwtDecoded = try? DecodedJWT(jwt: jwt)
    }
}

private extension GeneralResponse {
    enum CodingKeys: String, CodingKey {
        case jwt
    }
}
