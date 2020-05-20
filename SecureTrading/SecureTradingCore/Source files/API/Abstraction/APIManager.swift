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

// todo

@objc public protocol APIManagerObjc: AnyObject {
    func makeGeneralRequest(jwt: String, request: RequestObject, success: @escaping ((_ jwtResponse: JWTResponseObject, _ jwt: String) -> Void), failure: @escaping ((_ error: NSError) -> Void))
    func makeGeneralRequests(jwt: String, requests: [RequestObject], success: @escaping ((_ jwtResponses: [JWTResponseObject], _ jwt: String) -> Void), failure: @escaping ((_ error: NSError) -> Void))
}

public protocol APIManager {
    func makeGeneralRequest(jwt: String, request: RequestObject, success: @escaping ((_ jwtResponse: JWTResponseObject, _ jwt: String) -> Void), failure: @escaping ((_ error: APIClientError) -> Void))
    func makeGeneralRequests(jwt: String, requests: [RequestObject], success: @escaping ((_ jwtResponses: [JWTResponseObject], _ jwt: String) -> Void), failure: @escaping ((_ error: APIClientError) -> Void))
}
