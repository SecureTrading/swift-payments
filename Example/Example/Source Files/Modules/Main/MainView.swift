//
//  MainView.swift
//  Example
//

import UIKit

final class MainView: WhiteBackgroundBaseView {
    // TODO: change after merge
    var showDropInControllerWithWarningsButtonTappedClosure: (() -> Void)?

    fileprivate var items: [Section] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override init() {
        super.init()
        // setup data source
        items = [
            Section.onSDK(rows: [Row.performAuthRequestInBackground,
                                 Row.presentSingleInputComponents,
                                 Row.presentPayByCardForm,
                                 Row.performAccountCheck,
                                 Row.performAccountCheckWithAuth,
                                 Row.presentAddCardForm]),
            Section.onMerchant(rows: [Row.presentWalletForm])
        ]
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(dequeueableCell: MainViewTableViewCell.self)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()

    // callbacks for selected rows
    var showTestMainScreenButtonTappedClosure: (() -> Void)?
    var showTestMainFlowButtonTappedClosure: (() -> Void)?
    var makeAuthRequestButtonTappedClosure: (() -> Void)?
    var showSingleInputViewsButtonTappedClosure: (() -> Void)?
    var showDropInControllerButtonTappedClosure: (() -> Void)?
    var accountCheckRequest: (() -> Void)?
    var accountCheckWithAuthRequest: (() -> Void)?
    var addCardReferenceRequest: (() -> Void)?
    var payWithWalletRequest: (() -> Void)?
}

extension MainView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([tableView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        tableView.addConstraints([
            equal(self, \.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 0),
            equal(self, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            equal(self, \.leadingAnchor, constant: 0),
            equal(self, \.trailingAnchor, constant: 0)
        ])
    }
}

// MARK: Wallet view table data source and delegate
extension MainView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeue(dequeueableCell: MainViewTableViewCell.self)
        cell.configure(title: item.title)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rows.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let title = items[section].title {
            let header = UIView()
            header.backgroundColor = UIColor.groupTableViewBackground
            let label = UILabel()
            label.text = title
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
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch items[indexPath.section].rows[indexPath.row] {
        case .testMainScreen:
            showTestMainScreenButtonTappedClosure?()
        case .testMainFlow:
            showTestMainFlowButtonTappedClosure?()
        case .performAuthRequestInBackground:
            makeAuthRequestButtonTappedClosure?()
        case .presentSingleInputComponents:
            showSingleInputViewsButtonTappedClosure?()
        case .presentPayByCardForm:
            showDropInControllerButtonTappedClosure?()
        case .performAccountCheck:
            accountCheckRequest?()
        case .performAccountCheckWithAuth:
            accountCheckWithAuthRequest?()
        case .presentAddCardForm:
            addCardReferenceRequest?()
        case .presentWalletForm:
            payWithWalletRequest?()
        }
    }
}

private enum Row {
    case testMainScreen
    case testMainFlow
    case performAuthRequestInBackground
    case presentSingleInputComponents
    case presentPayByCardForm
    case performAccountCheck
    case performAccountCheckWithAuth
    case presentAddCardForm
    case presentWalletForm

    var title: String {
        switch self {
        case .testMainScreen:
            return Localizable.MainView.showTestMainScreenButton.text
        case .testMainFlow:
            return Localizable.MainView.showTestMainFlowButton.text
        case .performAuthRequestInBackground:
            return Localizable.MainView.makeAuthRequestButton.text
        case .presentSingleInputComponents:
            return Localizable.MainView.showSingleInputViewsButton.text
        case .presentPayByCardForm:
            return Localizable.MainView.showDropInControllerButton.text
        case .performAccountCheck:
            return Localizable.MainView.makeAccountCheckRequestButton.text
        case .performAccountCheckWithAuth:
            return Localizable.MainView.makeAccountCheckWithAuthRequestButton.text
        case .presentAddCardForm:
            return Localizable.MainView.addCardReferenceButton.text
        case .presentWalletForm:
            return Localizable.MainView.payWithWalletButton.text
        }
    }
}
private enum Section {
    case onMerchant(rows: [Row])
    case onSDK(rows: [Row])

    var rows: [Row] {
        switch self {
        case .onMerchant(let rows): return rows
        case .onSDK(let rows): return rows
        }
    }

    var title: String? {
        switch self {
        case .onMerchant: return Localizable.MainView.merchantResponsibility.text
        case .onSDK: return Localizable.MainView.sdkResponsibility.text
        }
    }
}

// MARK: Translations
fileprivate extension Localizable {
    enum MainView: String, Localized {
        case showTestMainScreenButton
        case showTestMainFlowButton
        case makeAuthRequestButton
        case showSingleInputViewsButton
        case showDropInControllerButton
        case showDropInControllerWithWarningsButton
        case makeAccountCheckRequestButton
        case makeAccountCheckWithAuthRequestButton
        case addCardReferenceButton
        case payWithWalletButton
        case merchantResponsibility
        case sdkResponsibility
    }
}
