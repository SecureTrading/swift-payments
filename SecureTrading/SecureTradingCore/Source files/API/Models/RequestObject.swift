//
//  RequestObject.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

enum TypeDescription: String, Codable {
    case auth = "AUTH"
}

struct RequestObject: Codable {
    let typeDescriptions: [TypeDescription]
}

private extension RequestObject {
    enum CodingKeys: String, CodingKey {
        case typeDescriptions = "requesttypedescriptions"
    }
}
