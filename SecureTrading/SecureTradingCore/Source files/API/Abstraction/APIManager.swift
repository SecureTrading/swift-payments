//
//  APIManager.swift
//  SecureTradingCore
//

import Foundation

@objc public enum GatewayType: Int {
    case eu
    case us

    var host: String {
        switch self {
        case .eu:
            return "webservices.securetrading.net"
        case .us:
            return "webservices.securetrading.us"
        }
    }
}

/// Performs payment transactions - workaround for objc to expose api client errors.
@objc public protocol APIManagerObjc: AnyObject {
    /// Performs the payment transaction request
    /// - Parameters:
    ///   - jwt: encoded JWT token
    ///   - request: object in which transaction parameters should be specified (e.g. what type - auth, 3dsecure etc)
    ///   - success: success closure with response object (decoded transaction response, in which settle status and transaction error code can be checked), and and a JWT key that allows you to check the signature
    ///   - failure: failure closure with general APIClient error like: connection error, server error, decoding problem
    func makeGeneralRequest(jwt: String, request: RequestObject, success: @escaping ((_ jwtResponse: JWTResponseObject, _ jwt: String) -> Void), failure: @escaping ((_ error: NSError) -> Void))
    /// Performs the payment transaction requests
    /// - Parameters:
    ///   - jwt: encoded JWT token
    ///   - requests: request objects (in each object transaction parameters should be specified - e.g. what type - auth, 3dsecure etc)
    ///   - success: success closure with response objects (decoded transaction responses, in which settle status and transaction error code can be checked), and and a JWT key that allows you to check the signature
    ///   - failure: failure closure with general APIClient error like: connection error, server error, decoding problem
    func makeGeneralRequests(jwt: String, requests: [RequestObject], success: @escaping ((_ jwtResponses: [JWTResponseObject], _ jwt: String) -> Void), failure: @escaping ((_ error: NSError) -> Void))
}

/// Performs payment transactions.
public protocol APIManager {
    /// Performs the payment transaction request
    /// - Parameters:
    ///   - jwt: encoded JWT token
    ///   - request: object in which transaction parameters should be specified (e.g. what type - auth, 3dsecure etc)
    ///   - success: success closure with response object (decoded transaction response, in which settle status and transaction error code can be checked), and and a JWT key that allows you to check the signature
    ///   - failure: failure closure with general APIClient error like: connection error, server error, decoding problem
    func makeGeneralRequest(jwt: String, request: RequestObject, success: @escaping ((_ jwtResponse: JWTResponseObject, _ jwt: String) -> Void), failure: @escaping ((_ error: APIClientError) -> Void))
    /// Performs the payment transaction requests
    /// - Parameters:
    ///   - jwt: encoded JWT token
    ///   - requests: request objects (in each object transaction parameters should be specified - e.g. what type - auth, 3dsecure etc)
    ///   - success: success closure with response objects (decoded transaction responses, in which settle status and transaction error code can be checked), and and a JWT key that allows you to check the signature
    ///   - failure: failure closure with general APIClient error like: connection error, server error, decoding problem
    func makeGeneralRequests(jwt: String, requests: [RequestObject], success: @escaping ((_ jwtResponses: [JWTResponseObject], _ jwt: String) -> Void), failure: @escaping ((_ error: APIClientError) -> Void))
}
