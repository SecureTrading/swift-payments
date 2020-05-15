//
//  DecodedJWTObject.swift
//  SecureTradingCore
//

import Foundation

public extension JWT {
    /// Return a claim by it's name
    /// - Parameter name: name of the claim in the JWT object
    /// - Returns: a claim of the JWT
    func claim(name: String) -> Claim {
        let value = self.body[name]
        return Claim(value: value)
    }
}

struct DecodedJWT: JWT {
    let header: [String: Any]
    let body: [String: Any]
    let jwtBodyResponse: JWTBodyResponse
    let signature: String?
    let string: String

    init(jwt: String) throws {
        let parts = jwt.components(separatedBy: ".")
        guard parts.count == 3 else {
            throw DecodeError.invalidPartCount
        }

        self.header = try decodeJWTPart(parts[0])
        self.body = try decodeJWTPart(parts[1])
        self.jwtBodyResponse = try decodeJWTBodyByDecoder(parts[1])
        self.signature = parts[2]
        self.string = jwt
    }

    var issuer: String? { return claim(name: "iss").string }
    var audience: [String]? { return claim(name: "aud").array }
    var expiresAt: Date? { return claim(name: "exp").date }
    var subject: String? { return claim(name: "sub").string }
    var issuedAt: Date? { return claim(name: "iat").date }
    var notBefore: Date? { return claim(name: "nbf").date }
    var identifier: String? { return claim(name: "jti").string }

    var expired: Bool {
        guard let date = self.expiresAt else {
            return false
        }
        return date.compare(Date()) != ComparisonResult.orderedDescending
    }
}

private func base64UrlDecode(_ value: String) -> Data? {
    var base64 = value
        .replacingOccurrences(of: "-", with: "+")
        .replacingOccurrences(of: "_", with: "/")
    let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
    let requiredLength = 4 * ceil(length / 4.0)
    let paddingLength = requiredLength - length
    if paddingLength > 0 {
        let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
        base64 += padding
    }
    return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
}

private func decodeJWTPart(_ value: String) throws -> [String: Any] {
    guard let bodyData = base64UrlDecode(value) else {
        throw DecodeError.invalidBase64Url
    }

    guard let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
        throw DecodeError.invalidJSON
    }

    return payload
}

private func decodeJWTBodyByDecoder(_ value: String) throws -> JWTBodyResponse {
    guard let bodyData = base64UrlDecode(value) else {
        throw DecodeError.invalidBase64Url
    }

    let decoder = JWTBodyResponse.decoder
    guard let payload = try? decoder.decode(JWTBodyResponse.self, from: bodyData) else {
        throw DecodeError.invalidJSON
    }

    return payload
}
