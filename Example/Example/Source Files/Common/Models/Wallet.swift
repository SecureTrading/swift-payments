//
//  Wallet.swift
//  Example
//

import Foundation

/// An example implementation of Wallet functionality as a Singleton
/// Only for demo purposes
/// Real application should store those data in a local database or on its own backend and request when needed
class Wallet {
    private init() {
        // Left for now for testing purposes
        mockCards()
    }
    private var cards: [STCardReference] = []
    static let shared: Wallet = Wallet()

    /// Returns all added card references
    var allCards: [STCardReference] {
        return cards
    }

    private func mockCards() {
        for _ in 1...5 {
            cards.append(STCardReference(reference: "ref1", cardType: "VISA", pan: "4111#####1111"))
        }
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
