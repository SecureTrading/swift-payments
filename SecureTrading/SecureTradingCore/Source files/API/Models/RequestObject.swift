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

public class RequestObject: NSObject, Codable {
    let typeDescriptions: [TypeDescription]

    @objc public class func create(from url: URL) -> RequestObject {
        let decoder = JSONDecoder()
        let item = try! decoder.decode(RequestObject.self, from: try! Data(contentsOf: url))
        return item
    }

    public init(typeDescriptions: [TypeDescription]) {
        self.typeDescriptions = typeDescriptions
    }
}

private extension RequestObject {
    enum CodingKeys: String, CodingKey {
        case typeDescriptions = "requesttypedescriptions"
    }
}
