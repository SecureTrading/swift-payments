//
//  WalletCardTableViewCell.swift
//  Example
//

import SecureTradingCard
import UIKit

/// Table cell used for representing a card on Wallet list with type of Subtitle
final class WalletCardTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configures the cell with parameters of STCardReference
    /// - Parameter cardReference: card reference object
    func configure(cardReference: STCardReference) {
        imageView?.image = CardType.cardType(for: cardReference.cardType).logo
        textLabel?.text = cardReference.cardType
        detailTextLabel?.text = cardReference.maskedPan
        self.highlightIfNeeded()
    }
}
