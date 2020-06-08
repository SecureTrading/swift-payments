//
//  SingleInputView.swift
//  Example
//

import UIKit

final class SingleInputView: WhiteBackgroundBaseView {
    private lazy var cardNumberInput: CardNumberInputView = {
        CardNumberInputView(inputViewStyleManager: inputViewStyleManager)
    }()

    private lazy var expiryDateInput: ExpiryDateInputView = {
        ExpiryDateInputView(inputViewStyleManager: inputViewStyleManager)
    }()

    private lazy var cvcInput: CvcInputView = {
        CvcInputView(inputViewStyleManager: inputViewStyleManager)
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cardNumberInput, expiryDateInput, cvcInput])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    let inputViewStyleManager: InputViewStyleManager?

    // MARK: Initialization

     /// Initializes an instance of the receiver.
     /// - Parameters:
     ///   - inputViewStyleManager: instance of manager to customize view
     @objc public init(inputViewStyleManager: InputViewStyleManager?) {
         self.inputViewStyleManager = inputViewStyleManager
         super.init()
     }

     required init?(coder _: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}

extension SingleInputView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    @objc func setupProperties() {
        cardNumberInput.cardNumberInputViewDelegate = self
        cardNumberInput.becomeFirstResponder()
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([stackView])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        stackView.addConstraints([
            equal(self, \.centerYAnchor),
            equal(self, \.centerXAnchor)
        ])
    }
}

extension SingleInputView: CardNumberInputViewDelegate {
    func cardNumberInputViewDidComplete(_ cardNumberInputView: CardNumberInputView) {
        cvcInput.cardType = cardNumberInputView.cardType
        cvcInput.isEnabled = cardNumberInputView.isCVCRequired
    }

    func cardNumberInputViewDidChangeText(_ cardNumberInputView: CardNumberInputView) {
        cvcInput.cardType = cardNumberInputView.cardType
        cvcInput.isEnabled = cardNumberInputView.isCVCRequired
    }
}
