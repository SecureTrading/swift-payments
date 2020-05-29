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
        let sut = request!
        let encoded = try sut.encoder.encode(sut)
        let decoded = try JSONDecoder().decode(GeneralRequest.self, from: encoded)
        XCTAssertEqual(sut.description, decoded.description)
    }
    func test_pathIsJWT() throws {
        let sut = request!
        XCTAssertEqual(sut.path, "/jwt/")
    }
    func test_httpMethodIsPost() throws {
        let sut = request!
        XCTAssertEqual(sut.method, APIRequestMethod.post)
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
