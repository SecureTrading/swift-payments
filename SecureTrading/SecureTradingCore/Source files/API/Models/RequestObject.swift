//
//  RequestObject.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

public enum TypeDescription: String, Codable {
    case auth = "AUTH"
    case threeDQuery = "THREEDQUERY"
}

public struct RequestObject: Codable {
    let typeDescriptions: [TypeDescription]
}

private extension RequestObject {
    enum CodingKeys: String, CodingKey {
        case typeDescriptions = "requesttypedescriptions"
    }
}
