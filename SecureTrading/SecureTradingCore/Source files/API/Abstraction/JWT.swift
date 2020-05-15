//
//  JWTObject.swift
//  SecureTradingCore
//

import Foundation


// Protocol defining the form of the decoded JWT

public protocol JWT {
    /// contents of the token header
    var header: [String: Any] { get }
    /// token body part values
    var body: [String: Any] { get }
    /// token signature part
    var signature: String? { get }
    /// jwt string value
    var string: String { get }

    /// the value of the `iss` claim if available
    var issuer: String? { get }
    /// the value of the `aud` claim if available
    var audience: [String]? { get }
    /// the value of the`exp` claim if available
    var expiresAt: Date? { get }
    /// the value of the `sub` claim if available
    var subject: String? { get }
    /// the value of the `iat` claim if available
    var issuedAt: Date? { get }
    /// the value of the `nbf` claim if available
    var notBefore: Date? { get }
    /// the value of the`jti` claim if available
    var identifier: String? { get }

    /// It checks whether the token has expired at any given time using the `exp` claim. If there is no claim, it considers that the token has not expired.
    var expired: Bool { get }
}
