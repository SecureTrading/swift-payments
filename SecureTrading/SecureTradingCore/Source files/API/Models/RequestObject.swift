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
}

@objc public class RequestObject: NSObject, Codable {
    // MARK: Properties

    let typeDescriptions: [TypeDescription]
    let cardNumber: String?
    let securityCode: String?
    let expiryDate: String?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - typeDescriptions: request type
    ///   - cardNumber: This is the long number printed on the front of the customer’s card.
    ///   - securityCode: This is the three digit security code printed on the back of the card. (For AMEX cards, this is a 4 digit code found on the front of the card), This field is not strictly required.
    ///   - expiryDate: The expiry date printed on the card.
    public init(typeDescriptions: [TypeDescription], cardNumber: String? = nil, securityCode: String? = nil, expiryDate: String? = nil) {
        self.typeDescriptions = typeDescriptions
        self.cardNumber = cardNumber
        self.securityCode = securityCode
        self.expiryDate = expiryDate
    }

    // objc workaround
    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - typeDescriptions: request type
    ///   - cardNumber: This is the long number printed on the front of the customer’s card.
    ///   - securityCode: This is the three digit security code printed on the back of the card. (For AMEX cards, this is a 4 digit code found on the front of the card), This field is not strictly required.
    ///   - expiryDate: The expiry date printed on the card.
    @objc public convenience init(typeDescriptions: [Int], cardNumber: String? = nil, securityCode: String? = nil, expiryDate: String? = nil) {
        let objcTypes = typeDescriptions.compactMap { TypeDescriptionObjc(rawValue: $0) }
        self.init(typeDescriptions: objcTypes.map { TypeDescription(rawValue: $0.value)! }, cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate)
    }
}

private extension RequestObject {
    enum CodingKeys: String, CodingKey {
        case typeDescriptions = "requesttypedescriptions"
        case cardNumber = "pan"
        case securityCode = "securitycode"
        case expiryDate = "expirydate"
    }
}
