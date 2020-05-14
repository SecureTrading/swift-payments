//
//  APIResponse.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation

/// An API response representation that can be just decodable.
protocol APIResponse: Decodable {

    /// A decoder to be used when decoding a response.
    static var decoder: JSONDecoder { get }
}

extension APIResponse {

    static var decoder: JSONDecoder {
        return JSONDecoder()
    }
}
