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

    /// Stores temporary all card references
    //    private let cardReferences: [CardReferenceView]

    // MARK: Callbacks
    /// Tapped on Pay button
    var payWithWalletRequest: (() -> Void)? {
        get { return payButton.onTap }
        set { payButton.onTap = newValue }
    }
    /// Selected a card reference from a list
    var cardFromWalletSelected: ((STCardReference) -> Void)?

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

    var items: [Section] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    enum Row {
        case cardReference(STCardReference)
        case addCard(title: String)

        var card: STCardReference? {
            switch self {
            case .cardReference(let cardRef): return cardRef
            case .addCard: return nil
            }
        }
    }
    enum Section {
        case paymentMethods(rows: [Row])
        case addMethod(rows: [Row])

        var rows: [Row] {
            switch self {
            case .paymentMethods(let rows): return rows
            case .addMethod(let rows): return rows
            }
        }
        var title: String? {
            switch self {
            case .paymentMethods: return "PAYMENT METHODS"
            case .addMethod: return "Tap the card you wish to pay with and click the 'Pay' button to process the payment"
            }
        }
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - inputViewStyleManager: instance of manager to customize view
    @objc public init(walletCards: [STCardReference]) {
        super.init()
        items = [
            Section.paymentMethods(rows: walletCards.map { Row.cardReference($0) }),
            Section.addMethod(rows: [Row.addCard(title: "Add Payment method")])
        ]
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WalletView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.section].rows[indexPath.row] {
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
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rows.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.section].rows[indexPath.row] {
        case .addCard: return 44
        case .cardReference: return 70
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let title = items[section].title {
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
        switch items[section] {
        case .paymentMethods: return 40
        case .addMethod: return 70
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.section].rows[indexPath.row] {
        case .cardReference(let card):
            cardFromWalletSelected?(card)
            payButton.isEnabled = true
        case .addCard:
            payButton.isEnabled = false
            // TODO: show add card view
        }
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
