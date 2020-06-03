//
//  RequestObject.swift
//  SecureTradingCore
//

// objc workaround - when you add a new value to TypeDescription, you have to add it here too
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
    
    var code: Int {
        switch self {
        case .auth: return TypeDescriptionObjc.auth.rawValue
        case .threeDQuery: return TypeDescriptionObjc.threeDQuery.rawValue
        }
    }
}

@objc public class RequestObject: NSObject, Codable {

    // MARK: Properties

    let typeDescriptions: [TypeDescription]

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameter typeDescriptions: request type
    public init(typeDescriptions: [TypeDescription]) {
        self.typeDescriptions = typeDescriptions
    }

    // objc workaround
    /// Initializes an instance of the receiver.
    /// - Parameter typeDescriptions: request type
    @objc public convenience init(typeDescriptions: [Int]) {
        let objcTypes = typeDescriptions.compactMap { TypeDescriptionObjc(rawValue: $0) }
        self.init(typeDescriptions: objcTypes.map { TypeDescription(rawValue: $0.value)! })
    }

}

private extension RequestObject {
    enum CodingKeys: String, CodingKey {
        case typeDescriptions = "requesttypedescriptions"
    }
}
