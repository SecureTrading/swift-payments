//
//  DefaultAPIManager.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
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
                print(response.jwt)
            case let .failure(error):
                print(error)
            }
        }
    }

}
