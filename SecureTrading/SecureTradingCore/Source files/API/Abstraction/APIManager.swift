//
//  APIManager.swift
//  SecureTradingCore
//

import Foundation

@objc public enum GatewayType: Int {
    case european
    case us

    var host: String {
        switch self {
        case .european:
            return "webservices.securetrading.net"
        case .us:
            return "webservices.securetrading.us"
        }
    }
}

@objc public protocol APIManager: AnyObject {
    func makeGeneralRequest(jwt: String, requests: [RequestObject], success: @escaping ((_ jwtResponses: [JWTResponseObject], _ jwt: String) -> Void), failure: @escaping ((_ error: Error) -> Void))
    func checkJWTDecoding()
}
