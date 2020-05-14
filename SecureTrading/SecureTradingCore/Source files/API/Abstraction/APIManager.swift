//
//  APIManager.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
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
    func makeGeneralRequest(alias: String, jwt: String, version: String, requests: [RequestObject])
}
