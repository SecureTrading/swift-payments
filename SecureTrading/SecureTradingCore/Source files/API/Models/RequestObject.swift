//
//  RequestObject.swift
//  SecureTradingCore
//

// objc workaround - when you add a new value to TypeDescription, you have to add it here too
@objc public enum TypeDescriptionObjc: Int {
    case auth = 0
    case threeDQuery
    case accountCheck
    case jsInit
    case subscription

    public var value: String {
        switch self {
        case .auth: return TypeDescription.auth.rawValue
        case .threeDQuery: return TypeDescription.threeDQuery.rawValue
        case .accountCheck: return TypeDescription.accountCheck.rawValue
        case .jsInit: return TypeDescription.jsInit.rawValue
        case .subscription: return TypeDescription.subscription.rawValue
        }
    }
}

public enum TypeDescription: String, Codable {
    case auth = "AUTH"
    case threeDQuery = "THREEDQUERY"
    case accountCheck = "ACCOUNTCHECK"
    case jsInit = "JSINIT"
    case subscription = "SUBSCRIPTION"

    var code: Int {
        switch self {
        case .auth: return TypeDescriptionObjc.auth.rawValue
        case .threeDQuery: return TypeDescriptionObjc.threeDQuery.rawValue
        case .accountCheck: return TypeDescriptionObjc.accountCheck.rawValue
        case .jsInit: return TypeDescriptionObjc.jsInit.rawValue
        case .subscription: return TypeDescriptionObjc.subscription.rawValue
        }
    }
}

@objc public class RequestObject: NSObject, Codable {
    // MARK: Properties

    let typeDescriptions: [TypeDescription]
    let requestId: String?
    let cardNumber: String?
    let securityCode: String?
    let expiryDate: String?
    let termUrl: String?
    let threeDResponse: String?
    let cacheToken: String?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - typeDescriptions: request types
    ///   - cardNumber: The long number printed on the front of the customer’s card.
    ///   - securityCode: The three digit security code printed on the back of the card. (For AMEX cards, this is a 4 digit code found on the front of the card), This field is not strictly required.
    ///   - expiryDate: The expiry date printed on the card.
    ///   - termUrl: terms url
    ///   - threeDResponse: JWT token for validation
    ///   - requestId: request id (to tie up the requests)
    ///   - cacheToken: cache token (to tie up the requests)
    public init(typeDescriptions: [TypeDescription], requestId: String? = nil, cardNumber: String? = nil, securityCode: String? = nil, expiryDate: String? = nil, termUrl: String? = nil, threeDResponse: String? = nil, cacheToken: String? = nil) {
        self.typeDescriptions = typeDescriptions
        self.requestId = requestId
        self.cardNumber = cardNumber
        self.securityCode = securityCode
        self.expiryDate = expiryDate
        self.termUrl = termUrl
        self.threeDResponse = threeDResponse
        self.cacheToken = cacheToken
    }

    // objc workaround
    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - typeDescriptions: request types
    ///   - cardNumber: The long number printed on the front of the customer’s card.
    ///   - securityCode: The three digit security code printed on the back of the card. (For AMEX cards, this is a 4 digit code found on the front of the card), This field is not strictly required.
    ///   - expiryDate: The expiry date printed on the card.
    ///   - termUrl: terms url
    ///   - threeDResponse: JWT token for validation
    ///   - requestId: request id (to tie up the requests)
    ///   - cacheToken: cache token (to tie up the requests)
    @objc public convenience init(typeDescriptions: [Int], requestId: String? = nil, cardNumber: String? = nil, securityCode: String? = nil, expiryDate: String? = nil, termUrl: String? = nil, threeDResponse: String? = nil, cacheToken: String? = nil) {
        let objcTypes = typeDescriptions.compactMap { TypeDescriptionObjc(rawValue: $0) }
        self.init(typeDescriptions: objcTypes.map { TypeDescription(rawValue: $0.value)! }, requestId: requestId, cardNumber: cardNumber, securityCode: securityCode, expiryDate: expiryDate, termUrl: termUrl, threeDResponse: threeDResponse, cacheToken: cacheToken)
    }
}

private extension RequestObject {
    enum CodingKeys: String, CodingKey {
        case typeDescriptions = "requesttypedescriptions"
        case requestId = "requestid"
        case cardNumber = "pan"
        case securityCode = "securitycode"
        case expiryDate = "expirydate"
        case termUrl = "termurl"
        case threeDResponse = "threedresponse"
        case cacheToken = "cachetoken"
    }
}
