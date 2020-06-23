//
//  MainViewTableViewCell.swift
//  Example
//

import UIKit

class MainViewTableViewCell: UITableViewCell {
    func configure(title: String?, hasDetailedInfo: Bool) {
        textLabel?.numberOfLines = 0
        textLabel?.text = title
        textLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        accessoryType = hasDetailedInfo ? .detailButton : .none
    }
}
