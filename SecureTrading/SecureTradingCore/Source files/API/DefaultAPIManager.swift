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

    public init(gatewayType: GatewayType) {
        let configuration = DefaultAPIClientConfiguration(scheme: .https, host: gatewayType.host)
        self.apiClient = DefaultAPIClient(configuration: configuration)
    }

    public func makeGeneralRequest(alias: String, jwt: String, version: String, requests: [RequestObject]) {
        let generalRequest = GeneralRequest(alias: alias, jwt: jwt, version: version, requests: requests)
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
