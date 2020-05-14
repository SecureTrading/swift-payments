//
//  APIManager.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation

public enum GatewayType {
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

protocol APIManager: AnyObject {}
