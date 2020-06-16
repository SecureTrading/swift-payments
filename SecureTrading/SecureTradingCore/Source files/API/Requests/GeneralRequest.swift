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

    func isValidAgainstResponse(_ response: APIResponse) -> Bool {
        // todo - probably to remove
        return true
        // check if response type description is the same as request type description
        // most likely to be adjusted for request with multiple types, like auth and 3dsecure
        guard let generalResponses = (response as? GeneralResponse)?.jwtResponses else { return true }
        let allRequestTypes = requests.flatMap { $0.typeDescriptions }
        // check if types were provided in request
        guard !allRequestTypes.isEmpty else { return true }
        let containedTypes = allRequestTypes.filter { type in
            generalResponses.contains(where: {$0.requestTypeDescription(contains: type)})
        }
        return containedTypes == allRequestTypes
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
