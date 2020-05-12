//
//  UITableView.swift
//  SecureTradingUI
//

import UIKit.UITableView

extension UITableViewCell: Dequeueable {}

extension UITableView {
    func register<Cell: UITableViewCell>(dequeueableCell _: Cell.Type) {
        register(Cell.self, forCellReuseIdentifier: Cell.defaultReuseIdentifier)
    }

    func dequeue<Cell: UITableViewCell>(dequeueableCell: Cell.Type, forIndexPath indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: dequeueableCell.defaultReuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell of type \(Cell.self) with reuseIdentifier \(Cell.defaultReuseIdentifier)")
        }
        return cell
    }

    func dequeue<Cell: UITableViewCell>(dequeueableCell: Cell.Type) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: dequeueableCell.defaultReuseIdentifier) as? Cell else {
            fatalError("Could not dequeue cell of type \(Cell.self) with reuseIdentifier \(Cell.defaultReuseIdentifier)")
        }
        return cell
    }
}
