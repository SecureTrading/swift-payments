//
//  JWTHelper.swift
//  Example
//

import Foundation
import SwiftJWT

/// Helper class for creating and signing JSON Web Tokens
/// used for communication with ST Gateway
final class JWTHelper {
    
    static func createJWT<T: Claims>(basedOn claim: T, signWith secret: String) -> String? {
        //<header>.<payload>.<signature>
        // default header
        let header = Header(typ: "JWT")
        
        // base JWT without signature
        var jwt = JWT(header: header, claims: claim)
        guard let keyData = secret.data(using: .utf8) else {
            AppLog.log("Missing secret data")
            return nil
        }
        let jwtSigner = JWTSigner.hs256(key: keyData)
        
        // sign jwt with key
        guard let signedJWT = try? jwt.sign(using: jwtSigner)  else {
            AppLog.log("Error while signing JWT: Missing secret key")
            return nil
        }

        // verify JWT
        let jwtVerifier = JWTVerifier.hs256(key: keyData)
        guard JWT<T>.verify(signedJWT, using: jwtVerifier) else {
            AppLog.log("Could not verify signed token")
            return nil
        }
        
        return signedJWT
    }
}
