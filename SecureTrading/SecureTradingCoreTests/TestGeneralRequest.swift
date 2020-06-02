//
//  TestGeneralRequest.swift
//  SecureTradingCoreTests
//

import XCTest
@testable import SecureTradingCore

class TestGeneralRequest: XCTestCase {
    
    var request: GeneralRequest!
    
    override func setUp() {
        super.setUp()
        request = GeneralRequest(alias: "alias", jwt: "jwt.jwt.jwt", version: "1.0", versionInfo: "Info version", requests: [])
    }
    func test_encodedDoesntLoseData() throws {
        let encoded = try request.encoder.encode(request)
        let decoded = try JSONDecoder().decode(GeneralRequest.self, from: encoded)
        XCTAssertEqual(request.description, decoded.description)
    }
    func test_pathIsJWT() throws {
        XCTAssertEqual(request.path, "/jwt/")
    }
    func test_httpMethodIsPost() throws {
        XCTAssertEqual(request.method, APIRequestMethod.post)
    }
}

extension GeneralRequest: Decodable {
    enum CodingKeys: String, CodingKey {
        case alias
        case jwt
        case version
        case versionInfo = "versioninfo"
        case requests = "request"
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let alias = try container.decode(String.self, forKey: .alias)
        let jwt = try container.decode(String.self, forKey: .jwt)
        let version = try container.decode(String.self, forKey: .version)
        let versionInfo = try container.decode(String.self, forKey: .versionInfo)
        self.init(alias: alias, jwt: jwt, version: version, versionInfo: versionInfo, requests: [])
    }
}
