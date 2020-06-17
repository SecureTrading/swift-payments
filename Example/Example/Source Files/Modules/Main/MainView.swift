//
//  MainView.swift
//  Example
//

import UIKit

final class MainView: WhiteBackgroundBaseView {

    /// data source for table view
    weak var dataSource: MainViewModelDataSource?

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

    fileprivate lazy var highlightViewsControl: UIView = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(toggleAction(_:)), for: .valueChanged)
        let label = UILabel()
        label.text = "Highlight views based on responsibility"

        let legendLabel = UILabel()
        let merchFirst = NSMutableAttributedString(string: "---", attributes: [NSAttributedString.Key.foregroundColor: UIColor.green, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        let merchSecond = NSAttributedString(string: " Merchant", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        merchFirst.append(merchSecond)
        let sdkFirst = NSMutableAttributedString(string: "  ---", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
        merchFirst.append(sdkFirst)
        let sdkSecond = NSAttributedString(string: " SDK", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        merchFirst.append(sdkSecond)
        legendLabel.attributedText = merchFirst

        let rightStack = UIStackView(arrangedSubviews: [label, legendLabel])
        rightStack.axis = .vertical
        rightStack.distribution = .equalSpacing
        rightStack.alignment = .fill
        let stack = UIStackView(arrangedSubviews: [toggle, rightStack])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 10
        return stack
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
    var showDropInControllerWithWarningsButtonTappedClosure: (() -> Void)?

    @objc func toggleAction(_ sender: UISwitch) {
        StyleManager.shared.highlightViewsBasedOnResponsibility = sender.isOn
    }
}

extension MainView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([tableView, highlightViewsControl])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        tableView.addConstraints([
            equal(self, \.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 0),
            equal(self, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            equal(self, \.leadingAnchor, constant: 0),
            equal(self, \.trailingAnchor, constant: 0)
        ])
        highlightViewsControl.addConstraints([
            equal(self, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            equal(self, \.leadingAnchor, constant: 20),
            equal(self, \.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: Wallet view table data source and delegate
extension MainView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource?.row(at: indexPath)
        let cell = tableView.dequeue(dequeueableCell: MainViewTableViewCell.self)
        cell.configure(title: item?.title)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections() ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(at: section) ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let title = dataSource?.title(for: section) {
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
        guard let row = dataSource?.row(at: indexPath) else { return }
        switch row {
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
        case .showDropInControllerWithWarnings:
            showDropInControllerWithWarningsButtonTappedClosure?()
        }
    }
}
