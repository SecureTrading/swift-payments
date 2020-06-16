//
//  MainView.swift
//  Example
//

import UIKit

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
    case mainHeader
    case onMerchant(rows: [Row])
    case onSDK(rows: [Row])

    var rows: [Row] {
        switch self {
        case .mainHeader: return []
        case .onMerchant(let rows): return rows
        case .onSDK(let rows): return rows
        }
    }

    var title: NSAttributedString? {
        switch self {
        case .mainHeader:
            let pinkyColor = UIColor(red: 226.0 / 255.0, green: 34.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0)
            let secure = NSMutableAttributedString(string: "secure", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black])
            let slash = NSAttributedString(string: "//", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25), NSAttributedString.Key.foregroundColor: pinkyColor])
            secure.append(slash)
            let trading = NSAttributedString(string: "trading", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor: UIColor.black])
            secure.append(trading)
            return secure
        case .onMerchant:
            return NSAttributedString(string: "Merchant responsibility", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        case .onSDK:
            return NSAttributedString(string: "ST SDK responsibility", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
    }
}

final class MainView: WhiteBackgroundBaseView {
    fileprivate var items: [Section] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override init() {
        super.init()

        // setup data source
        items = [
            Section.mainHeader,
            Section.onSDK(rows: [Row.performAuthRequestInBackground, Row.presentSingleInputComponents, Row.presentPayByCardForm, Row.performAccountCheck, Row.performAccountCheckWithAuth, Row.presentAddCardForm]),
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

fileprivate extension Localizable {
    enum MainView: String, Localized {
        case showTestMainScreenButton
        case showTestMainFlowButton
        case makeAuthRequestButton
        case showSingleInputViewsButton
        case showDropInControllerButton
        case makeAccountCheckRequestButton
        case makeAccountCheckWithAuthRequestButton
        case addCardReferenceButton
        case payWithWalletButton
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
        switch items[section] {
        case .mainHeader:
            if let title = items[section].title {
                let header = UIView()
                header.backgroundColor = UIColor.white
                let label = UILabel()
                label.attributedText = title
                label.numberOfLines = 0
                label.textAlignment = .center
                header.addSubview(label)
                label.addConstraints([
                    equal(header, \.topAnchor, \.topAnchor, constant: 2),
                    equal(header, \.bottomAnchor, \.bottomAnchor, constant: 2),
                    equal(header, \.leadingAnchor, \.leadingAnchor, constant: 20),
                    equal(header, \.trailingAnchor, \.trailingAnchor, constant: -20)
                ])
                return header
            }
        default:
            if let title = items[section].title {
                let header = UIView()
                header.backgroundColor = UIColor.groupTableViewBackground
                let label = UILabel()
                label.attributedText = title
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
