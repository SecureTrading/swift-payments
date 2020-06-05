//
//  JWTResponse.swift
//  SecureTradingCore
//

@objc public enum ResponseErrorCode: Int {
    case successful = 0
    case transactionNotAuhorised = 60_022
    case declinedByIssuingBank = 70_000
    case fieldError = 30_000
    case bankSystemError = 60_010
    case manualInvestigationRequired = 60_034
    case unknown = 99_999
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
@objc public enum ResponseErrorDetail: Int {
    case invalidPAN
    case invalidSecurityCode
    case invalidJWT
    case invalidExpiryDate
    case invalidTermURL
    case none
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
    
    @objc public var errorDetails: ResponseErrorDetail {
        // confirmed with ST, error data will only have max 1 element at the time,
        // even when there are multiple errors
        // errors are parsed one by one on the gateway

        switch responseErrorCode {
        case .fieldError:
            switch errorData?.first {
            case "pan": return ResponseErrorDetail.invalidPAN
            case "jwt": return ResponseErrorDetail.invalidJWT
            case "securitycode": return ResponseErrorDetail.invalidSecurityCode
            case "expirydate": return ResponseErrorDetail.invalidExpiryDate
            case "termurl": return ResponseErrorDetail.invalidTermURL
            default: return ResponseErrorDetail.none
            }
        default: return ResponseErrorDetail.none
        }
    }
    
    private var requestTypeDescription: TypeDescription?
    
    // MARK: Initialization
    
    /// - SeeAlso: Swift.Decodable
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let errorCodeString = try container.decode(String.self, forKey: .errorCode)
        errorCode = Int(errorCodeString) ?? -1
        errorMessage = try container.decode(String.self, forKey: .errorMessage)
        errorData = try container.decodeIfPresent([String].self, forKey: .errorData)
        if let settleStatusString = try container.decodeIfPresent(String.self, forKey: .settleStatus), let settleStatusInt = Int(settleStatusString) {
            settleStatus = NSNumber(value: settleStatusInt)
        } else {
            settleStatus = nil
        }
        transactionReference = try container.decodeIfPresent(String.self, forKey: .transactionReference)
        if let type = try container.decodeIfPresent(String.self, forKey: .requestTypeDescription), let typeDescription = TypeDescription(rawValue: type) {
            requestTypeDescription = typeDescription
        } else {
            requestTypeDescription = nil
        }
    }
    
    // MARK: Methods
    public func requestTypeDescription(contains description: TypeDescription) -> Bool {
        guard let type = requestTypeDescription else { return false }
        return description.rawValue == type.rawValue
    }
    @objc public func requestTypeDescription(contains description: TypeDescriptionObjc) -> Bool {
        guard let type = requestTypeDescription else { return false }
        return description.rawValue == type.code
    }
}

private extension JWTResponseObject {
    enum CodingKeys: String, CodingKey {
        case errorCode = "errorcode"
        case errorMessage = "errormessage"
        case errorData = "errordata"
        case settleStatus = "settlestatus"
        case transactionReference = "transactionreference"
        case requestTypeDescription = "requesttypedescription"
    }
}
