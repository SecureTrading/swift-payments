//
//  DefaultAPIManager.swift
//  SecureTradingCore
//

import Foundation

@objc public final class DefaultAPIManager: NSObject, APIManager {

    private let apiClient: APIClient
    private let username: String
    private let version = "1.00"

    @objc public init(gatewayType: GatewayType, username: String) {
        self.username = username
        let configuration = DefaultAPIClientConfiguration(scheme: .https, host: gatewayType.host)
        self.apiClient = DefaultAPIClient(configuration: configuration)
    }

    @objc public func makeGeneralRequest(jwt: String, requests: [RequestObject]) {
        let generalRequest = GeneralRequest(alias: self.username, jwt: jwt, version: self.version, requests: requests)
        apiClient.perform(request: generalRequest) { (result) in
            switch result {
            case let .success(response):
                guard let jwtResponses = response.jwtResponses else {
                    // todo failure
                    return

                    // todo handle error codes

                }
            case let .failure(error):
                // todo return error closure
                break
            }
        }
    }

}
