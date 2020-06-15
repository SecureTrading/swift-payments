//
//  WalletAddCardTableViewCell.swift
//  Example
//

import UIKit

class WalletAddCardTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        textLabel?.text = title
        accessoryType = .disclosureIndicator
    }
}
