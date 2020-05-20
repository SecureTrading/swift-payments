//
//  DefaultAPIManager.swift
//  SecureTradingCore
//

import Foundation

@objc public final class DefaultAPIManager: NSObject, APIManager {

    // MARK: Properties

    /// - SeeAlso: APIClient
    private let apiClient: APIClient
    /// merchant's username
    private let username: String
    /// JSON format version
    private let version = "1.00"

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - gatewayType: gateway type (us or european)
    ///   - username: merchant's username
    @objc public init(gatewayType: GatewayType, username: String) {
        self.username = username
        let configuration = DefaultAPIClientConfiguration(scheme: .https, host: gatewayType.host)
        self.apiClient = DefaultAPIClient(configuration: configuration)
    }

    // MARK: Functions

    // todo
    @objc public func makeGeneralRequest(jwt: String, request: RequestObject, success: @escaping ((_ jwtResponse: JWTResponseObject, _ jwt: String) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        let generalRequest = GeneralRequest(alias: self.username, jwt: jwt, version: self.version, requests: [request])
        self.apiClient.perform(request: generalRequest) { result in
            switch result {
            case let .success(response):
                success(response.jwtResponses.first!, jwt)
            case let .failure(error):
                failure(error)
            }
        }
    }

    // todo
    @objc public func makeGeneralRequests(jwt: String, requests: [RequestObject], success: @escaping ((_ jwtResponses: [JWTResponseObject], _ jwt: String) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        let generalRequest = GeneralRequest(alias: self.username, jwt: jwt, version: self.version, requests: requests)
        self.apiClient.perform(request: generalRequest) { result in
            switch result {
            case let .success(response):
                success(response.jwtResponses, jwt)
            case let .failure(error):
                failure(error)
            }
        }
    }

}
