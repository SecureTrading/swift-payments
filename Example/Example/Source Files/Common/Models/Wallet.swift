//
//  Wallet.swift
//  Example
//

import Foundation

/// An example implementation of Wallet functionality as a Singlgeton
/// Only for demo purposes
/// Real application should store those data in a database
class Wallet {
    private init() {}
    private var cards: [STCardReference] = []
    static let shared: Wallet = Wallet()

    /// Returns all added card references
    var allCards: [STCardReference] {
        return cards
    }

    /// Removes all card references
    func removeAll() {
        cards.removeAll()
    }

    /// Adds a card reference to wallet
    /// takes optional value and if has wrapped part, adds it to the collection
    func add(card: STCardReference?) {
        guard let card = card else { return }
        cards.append(card)
    }
}
