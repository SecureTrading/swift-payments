//
//  STCardReference.swift
//  SecureTradingCore
//

import Foundation

/// Represents a transaction and card details used for that transaction
/// Can be used for future payments without the need to provide all card details
@objc public class STCardReference: NSObject {
    public let transactionReference: String?
    public let cardType: String
    public let maskedPan: String

    /// Initialize a card reference object
    /// - Parameters:
    ///   - reference: transaction reference, returned on ACCOUNTCHECK
    ///   - cardType: String value representing card type, e.g VISA
    ///   - pan: masked pan number returned in response
    @objc public init(reference: String?, cardType: String, pan: String) {
        self.transactionReference = reference
        self.cardType = cardType
        self.maskedPan = pan
    }
}
