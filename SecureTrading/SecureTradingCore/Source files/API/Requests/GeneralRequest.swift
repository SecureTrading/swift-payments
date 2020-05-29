//
//  AuthRequest.swift
//  SecureTradingCore
//

import Foundation

struct GeneralRequest: APIRequestModel {

    // MARK: Properties

    private let alias: String
    private let jwt: String
    private let version: String
    private let versionInfo: String
    private let requests: [RequestObject]

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - alias: merchant's username
    ///   - jwt: generated jwt token
    ///   - version: JSON format version
    ///   - versionInfo: information about swift language, sdk version, ios version
    ///   - requests: array of request objects
    init(alias: String, jwt: String, version: String, versionInfo: String, requests: [RequestObject]) {
        self.alias = alias
        self.jwt = jwt
        self.version = version
        self.versionInfo = versionInfo
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
        return "/jwt/"
    }

    /// - SeeAlso: Swift.Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(alias, forKey: .alias)
        try container.encode(jwt, forKey: .jwt)
        try container.encode(version, forKey: .version)
        try container.encode(versionInfo, forKey: .versionInfo)
        try container.encode(requests, forKey: .requests)
    }
}

private extension GeneralRequest {
    enum CodingKeys: String, CodingKey {
        case alias
        case jwt
        case version
        case versionInfo = "versioninfo"
        case requests = "request"
    }
}

extension GeneralRequest: CustomStringConvertible {
    var description: String {
        return "\(alias), \(jwt), \(version), \(versionInfo)"
    }
}
