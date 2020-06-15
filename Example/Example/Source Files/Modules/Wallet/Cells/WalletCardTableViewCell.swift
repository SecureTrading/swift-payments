//
//  WalletCardTableViewCell.swift
//  Example
//

import SecureTradingCard
import UIKit

class WalletCardTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(cardReference: STCardReference) {
        imageView?.image = CardType.cardType(for: cardReference.cardType).logo
        textLabel?.text = cardReference.cardType
        detailTextLabel?.text = cardReference.maskedPan
    }
}
