//
//  WalletAddCardTableViewCell.swift
//  Example
//

import UIKit

/// Table cell used for representing an option on Wallet list for adding a new payment method
final class WalletAddCardTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configures the table cell by setting a title property, has a disclosure indicator as an accessory type
    /// - Parameter title: Custom title to display
    func configure(title: String) {
        textLabel?.text = title
        accessoryType = .disclosureIndicator
    }
}
