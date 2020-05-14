//
//  RequestObject.swift
//  SecureTradingCore
//
//  Created by TIWASZEK on 14/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

// objc workaround
@objc public enum TypeDescriptionObjc: Int {
    case auth
    case threeDQuery

    var value: String {
        switch self {
        case .auth:
            return "AUTH"
        case .threeDQuery:
            return "THREEDQUERY"
        }
    }
}

public enum TypeDescription: String, Codable {
    case auth = "AUTH"
    case threeDQuery = "THREEDQUERY"
}

@objc public class RequestObject: NSObject, Codable {
    let typeDescriptions: [TypeDescription]

    public init(typeDescriptions: [TypeDescription]) {
        self.typeDescriptions = typeDescriptions
    }

    // objc workaround
    @objc public convenience init(typeDescriptions: [Int]) {
        let objcTypes = typeDescriptions.map { TypeDescriptionObjc(rawValue: $0)! }
        self.init(typeDescriptions: objcTypes.map { TypeDescription(rawValue: $0.value)! })
    }
}

private extension RequestObject {
    enum CodingKeys: String, CodingKey {
        case typeDescriptions = "requesttypedescriptions"
    }
}
