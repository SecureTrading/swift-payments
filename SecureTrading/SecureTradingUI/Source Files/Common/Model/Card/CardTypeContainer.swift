//
//  CardTypeRegister.swift
//  SecureTradingUI
//

import UIKit
import SecureTradingCard

/// This class is used to maintain the range of accepted card types. You can provide different sets of card types for CardNumberInputView and adjust the range of accepted card types individually.
public class CardTypeContainer {
    // MARK: Properties

    private(set) var cardTypes: [CardType]

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    public init() {
        cardTypes = []
    }

    /// Initializes an instance of the receiver.
    /// - Parameter cardTypes: Any sequence of `CardType`
    public convenience init<T: Sequence>(cardTypes: T) where T.Iterator.Element == CardType {
        self.init()
        setCardTypes(cardTypes)
    }

    // MARK: Functions

    /// Adds the provided card type to the card type array.
    /// - Parameter cardType: the card type
    public func add(cardType: CardType) {
        if cardTypes.contains(where: { $0 == cardType }) {
            return
        }
        cardTypes.append(cardType)
    }

    /// Removes the provided card type to the card type array.
    /// - Parameter cardType: the card type
    public func remove(cardType: CardType) {
        cardTypes = cardTypes.filter { $0 != cardType }
    }

    /// Resets and sets a new set of card types
    /// - Parameter cardTypes: new set of card types
    public func setCardTypes<T: Sequence>(_ cardTypes: T) where T.Iterator.Element == CardType {
        self.cardTypes = []
        self.cardTypes.append(contentsOf: cardTypes)
    }

}
