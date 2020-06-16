//
//  WalletView.swift
//  Example
//

import UIKit
import SecureTradingUI

/// An example implementation of Wallet functionality
final class WalletView: WhiteBackgroundBaseView {

    /// A button used for making the request with selected card reference
    public private(set) lazy var payButton: PayButton = {
        PayButton()
    }()

    // MARK: Callbacks
    /// Tapped on Pay button
    var payWithWalletRequest: (() -> Void)? {
        get { return payButton.onTap }
        set { payButton.onTap = newValue }
    }
    /// Selected a card reference from a list
    var cardFromWalletSelected: ((STCardReference) -> Void)?

    /// Data source for table view
    weak var dataSource: WalletViewModelDataSource?

    /// Called by selecting Add new Payment method cell
    var addNewPaymentMethod: (() -> Void)?

    // MARK: View hierarchy

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(dequeueableCell: WalletCardTableViewCell.self)
        tableView.register(dequeueableCell: WalletAddCardTableViewCell.self)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        return tableView
    }()

    /// Reloads table after adding a new payment method
    /// - Parameter cards: New card that has been added
    @objc public func reloadCards() {
        tableView.reloadData()
    }
}

extension WalletView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        self.addSubview(payButton)
        payButton.addConstraints([
            equal(self, \.bottomAnchor, \.bottomAnchor, constant: -40),
            equal(self, \.leadingAnchor, \.leadingAnchor, constant: 20),
            equal(self, \.trailingAnchor, \.trailingAnchor, constant: -20)
        ])
        addSubviews([tableView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        tableView.addConstraints([
            equal(self, \.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 0),
            equal(payButton, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            equal(self, \.leadingAnchor, constant: 0),
            equal(self, \.trailingAnchor, constant: 0)
        ])
    }
}

// MARK: Wallet view table data source and delegate
extension WalletView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = dataSource?.row(at: indexPath) else {
            fatalError("Where is the row")
        }
        switch row {
        case .cardReference(let cardReference):
            let cell = tableView.dequeue(dequeueableCell: WalletCardTableViewCell.self)
            cell.configure(cardReference: cardReference)
            return cell
        case .addCard(let title):
            let cell = tableView.dequeue(dequeueableCell: WalletAddCardTableViewCell.self)
            cell.configure(title: title)
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections() ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(at: section) ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource?.row(at: indexPath) {
        case .addCard: return 44
        case .cardReference: return 70
        case .none: return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let title = dataSource?.title(for: section) {
            let header = UIView()
            header.backgroundColor = UIColor.groupTableViewBackground
            let label = UILabel()
            label.text = title
            label.textColor = UIColor.gray
            label.numberOfLines = 0
            header.addSubview(label)
            label.addConstraints([
                equal(header, \.topAnchor, \.topAnchor, constant: 2),
                       equal(header, \.bottomAnchor, \.bottomAnchor, constant: 2),
                       equal(header, \.leadingAnchor, \.leadingAnchor, constant: 20),
                       equal(header, \.trailingAnchor, \.trailingAnchor, constant: -20)
                   ])
            return header
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch dataSource?.section(at: section) {
        case .paymentMethods: return 40
        case .addMethod(let showHeader, _): return showHeader ? 70 : 0
        case .none: return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = dataSource?.row(at: indexPath) else { return }
        switch row {
        case .cardReference(let card):
            cardFromWalletSelected?(card)
            payButton.isEnabled = true
        case .addCard:
            payButton.isEnabled = false
            tableView.deselectRow(at: indexPath, animated: false)
            addNewPaymentMethod?()
        }
    }
}

private extension Localizable {
    enum WalletView: String, Localized {
        case addPaymentMethod
        case paymentMethods
        case infoText
    }
}
