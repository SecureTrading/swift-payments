//
//  Unknown.swift
//  SecureTradingUI
//

public struct UnknownCard: CardType {
    public let name = "Unknown"
    public let cvcLength = 0
    public let identificationDigits: Set<Int> = []

    public init() {}
}
