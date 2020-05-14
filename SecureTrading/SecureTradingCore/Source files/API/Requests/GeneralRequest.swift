//
//  AuthRequest.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation

struct GeneralRequest: APIRequestModel {

    // MARK: Properties

    private let alias: String
    private let jwt: String
    private let version: String
    private let requests: [RequestObject]

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - alias: merchant username
    ///   - jwt: generated jwt token
    ///   - version: API version
    ///   - requests: array of request objects
    init(alias: String, jwt: String, version: String, requests: [RequestObject]) {
        self.alias = alias
        self.jwt = jwt
        self.version = version
        self.requests = requests
    }

    // MARK: APIRequestModel

    typealias Response = GeneralResponse

    /// - SeeAlso: APIRequestModel.method
    var method: APIRequestMethod {
        return .post
    }

    /// - SeeAlso: APIRequestModel.path
    var path: String {
        return "/jwt"
    }

}

private extension GeneralRequest {
    enum CodingKeys: String, CodingKey {
        case requests = "request"
    }
}
