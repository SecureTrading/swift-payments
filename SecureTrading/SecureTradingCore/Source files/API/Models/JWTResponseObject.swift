//
//  JWTResponse.swift
//  SecureTradingCore
//

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

@objc public enum ResponseSettleStatus: Int {
    case pendingAutomaticSettlement = 0
    case pendingManualSettlement = 1
    case settlementInProgress = 10
    case instantSettlement = 100
    case paymentAuthorisedButSuspended = 2
    case paymentCancelled = 3
    case error
}

@objc public class JWTResponseObject: NSObject, Decodable {
    // MARK: Properties

    @objc public let errorCode: Int
    @objc public let errorMessage: String

    @objc public let settleStatus: NSNumber?

    @objc public let transactionReference: String?

    @objc public let errorData: [String]?

    @objc public var responseErrorCode: ResponseErrorCode {
        return ResponseErrorCode(rawValue: errorCode) ?? .unknown
    }

    @objc public var responseSettleStatus: ResponseSettleStatus {
        return ResponseSettleStatus(rawValue: settleStatus?.intValue ?? -1) ?? .error
    }

    // MARK: Initialization

    /// - SeeAlso: Swift.Decodable
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let errorCodeString = try container.decode(String.self, forKey: .errorCode)
        errorCode = Int(errorCodeString)!
        errorMessage = try container.decode(String.self, forKey: .errorMessage)
        errorData = try container.decodeIfPresent([String].self, forKey: .errorData)
        if let settleStatusString = try container.decodeIfPresent(String.self, forKey: .settleStatus), let settleStatusInt = Int(settleStatusString) {
            settleStatus = NSNumber(value: settleStatusInt)
        } else {
            settleStatus = nil
        }
        transactionReference = try container.decodeIfPresent(String.self, forKey: .transactionReference)
    }
}

private extension JWTResponseObject {
    enum CodingKeys: String, CodingKey {
        case errorCode = "errorcode"
        case errorMessage = "errormessage"
        case errorData = "errordata"
        case settleStatus = "settlestatus"
        case transactionReference = "transactionreference"
    }
}
