//
//  WalletView.swift
//  Example
//

import UIKit
import SecureTradingUI

class WalletCell: UITableViewCell {

}
/// An example implementation of Wallet functionality
final class WalletView: WhiteBackgroundBaseView {

    /// A button used for making the request with selected card reference
    public private(set) lazy var payButton: PayButton = {
        PayButton()
    }()

    /// Stores temporary all card references
    private let cardReferences: [CardReferenceView]

    // MARK: Callbacks
    /// Tapped on Pay button
    var payWithWalletRequest: (() -> Void)? {
        get { return payButton.onTap }
        set { payButton.onTap = newValue }
    }
    /// Selected a card reference from a list
    var cardFromWalletSelected: ((STCardReference) -> Void)?

    // MARK: View hierarchy

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(dequeueableCell: WalletCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    private let stackViewLeadingConstraint = "stackViewLeadingConstraint"
    private let stackViewTrailingConstraint = "stackViewTrailingConstraint"
    private let stackViewTopConstraint = "stackViewTopConstraint"
    private let stackViewBottomConstraint = "stackViewBottomConstraint"

//    private let stackContainer: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear
//        return view
//    }()

//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: cardReferences)
//        stackView.axis = .vertical
//        stackView.spacing = 30
//        stackView.alignment = .fill
//        stackView.distribution = .fill
//        return stackView
//    }()

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - inputViewStyleManager: instance of manager to customize view
    @objc public init(walletCards: [STCardReference]) {
        cardReferences = walletCards.map { CardReferenceView(cardReference: $0) }
        super.init()

        // set up touch up inside handler for selecting/deselecting
        cardReferences.forEach { [weak self] cardView in
            guard let self = self else { return }
            cardView.tap = { (card, isSelected) in
                self.payButton.isEnabled = isSelected
                if isSelected {
                    self.unselectAll(except: cardView)
                    self.cardFromWalletSelected?(card)
                } else {
                    self.unselectAll()
                }
            }
        }
        tableView.reloadData()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions

    /// Unselects all cards in stack view
    /// - Parameter current: Current card reference, needed for omiting selection
    private func unselectAll(except current: CardReferenceView? = nil) {
        if let current = current {
            cardReferences.filter { $0 != current }.forEach { $0.isSelected = false }
        } else {
            cardReferences.forEach { $0.isSelected = false }
        }
    }
}

extension WalletView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(dequeueableCell: WalletCell.self)
        cell.textLabel?.text = cardReferences[indexPath.row].card.maskedPan
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardReferences.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

}
extension WalletView: ViewSetupable {

//    private func buildStackViewConstraints() {
//        stackContainer.constraint(withIdentifier: stackViewTopConstraint)?.isActive = false
//        stackContainer.constraint(withIdentifier: stackViewBottomConstraint)?.isActive = false
//        stackContainer.constraint(withIdentifier: stackViewLeadingConstraint)?.isActive = false
//        stackContainer.constraint(withIdentifier: stackViewTrailingConstraint)?.isActive = false
//
//        stackView.addConstraints([
//            equal(stackContainer, \.topAnchor, \.topAnchor, constant: 0, identifier: stackViewTopConstraint),
//            equal(stackContainer, \.bottomAnchor, \.bottomAnchor, constant: 0, identifier: stackViewBottomConstraint),
//            equal(stackContainer, \.leadingAnchor, \.leadingAnchor, constant: 0, identifier: stackViewLeadingConstraint),
//            equal(stackContainer, \.trailingAnchor, \.trailingAnchor, constant: 0, identifier: stackViewTrailingConstraint)
//        ])
//    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
//        stackContainer.addSubview(stackView)
//        scrollView.addSubview(stackContainer)
        addSubviews([tableView])
        self.addSubview(payButton)
        payButton.addConstraints([
            equal(self, \.bottomAnchor, \.bottomAnchor, constant: -40, identifier: stackViewBottomConstraint),
            equal(self, \.leadingAnchor, \.leadingAnchor, constant: 20, identifier: stackViewLeadingConstraint),
            equal(self, \.trailingAnchor, \.trailingAnchor, constant: -20, identifier: stackViewTrailingConstraint)
        ])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        print("a")

        tableView.addConstraints([
            equal(self, \.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 0),
            equal(self, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            equal(self, \.leadingAnchor, constant: 0),
            equal(self, \.trailingAnchor, constant: 0)
        ])
//
//        stackContainer.addConstraints(equalToSuperview(with: .init(top: 0, left: 20, bottom: 0, right: 20), usingSafeArea: false))
//
//        stackContainer.addConstraints([
//            equal(self, \.widthAnchor, to: \.widthAnchor, constant: 0.0)
//        ])
//
//        buildStackViewConstraints()
    }
}
