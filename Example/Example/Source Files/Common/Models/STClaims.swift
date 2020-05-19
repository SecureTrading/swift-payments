//
//  STClaims.swift
//  Example
//
//  Created by TIWASZEK on 19/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import SwiftJWT

struct STClaims: Claims {
    let iss: String
    let iat: Date // no later than 60mins from now
    let payload: Payload
}

struct Payload: Codable {
    let accounttypedescription: String
    let sitereference: String
    let currencyiso3a: String
    let baseamount: Int
    let pan: String
    let expirydate: String
    let securitycode: String
}
