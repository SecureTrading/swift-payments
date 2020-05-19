//
//  JWTResponse.swift
//  SecureTradingCore
//

// todo create localizable desc
@objc public enum ResponseErrorCode: Int {
    case successful = 0
    case transactionNotAuhorised = 60022
    case declinedByIssuingBank = 70000
    case fieldError = 3000
    case bankSystemError = 60010
    case manualInvestigationRequired = 60034
    case unknown = 99999
    case other
}

// todo create localizable desc
@objc public enum ResponseSettleStatus: Int {
    case pendingAutomaticSettlement = 0
    case pendingManualSettlement = 1
    case settlementInProgress = 10
    case instantSettlement = 100
    case paymentAuthorisedButSuspended = 2
    case paymentCancelled = 3
}

@objc public class JWTResponseObject: NSObject, Codable {
    
    // MARK: Properties

    let errorCode: Int
    let errorMessage: String

    let settleStatus: Int

    let transactionReference: String

    var responseErrorCode: ResponseErrorCode {
        return ResponseErrorCode(rawValue: errorCode) ?? .unknown
    }

    var responseSettleStatus: ResponseSettleStatus {
        return ResponseSettleStatus(rawValue: settleStatus)!
    }

    // MARK: Initialization

    /// - SeeAlso: Swift.Decodable
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let errorCodeString = try container.decode(String.self, forKey: .errorCode)
        errorCode = Int(errorCodeString)!
        errorMessage = try container.decode(String.self, forKey: .errorMessage)
        let settleStatusString = try container.decode(String.self, forKey: .settleStatus)
        settleStatus = Int(settleStatusString)!
        transactionReference = try container.decode(String.self, forKey: .transactionReference)
    }
}

private extension JWTResponseObject {
    enum CodingKeys: String, CodingKey {
        case errorCode = "errorcode"
        case errorMessage = "errormessage"
        case settleStatus = "settlestatus"
        case transactionReference = "transactionreference"
    }
}
