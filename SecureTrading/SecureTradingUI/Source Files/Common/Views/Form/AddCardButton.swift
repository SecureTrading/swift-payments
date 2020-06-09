//
//  AddCardButton.swift
//  SecureTradingUI
//

import UIKit

/// A subclass of RequestButton, consists of title and spinner for the request interval
@objc public final class AddCardButton: RequestButton {
    // MARK: Private properties

    let addCardButtonStyleManager: AddCardButtonStyleManager?

    // MARK: Public properties

    // MARK: - texts

    @objc public override var title: String {
        didSet {
            setTitle(title, for: .normal)
        }
    }

    // MARK: Initialization

    /// Initialize an instance and calls required methods
    /// - Parameters:
    ///   - addCardButtonStyleManager: instance of manager to customize view
    @objc public init(addCardButtonStyleManager: AddCardButtonStyleManager? = nil) {
        self.addCardButtonStyleManager = addCardButtonStyleManager
        super.init(requestButtonStyleManager: addCardButtonStyleManager)
        self.configureView()
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private functions

    public override func configureView() {
        super.configureView()
        self.title = Localizable.AddCardButton.title.text
    }
}

private extension Localizable {
    enum AddCardButton: String, Localized {
        case title
    }
}
