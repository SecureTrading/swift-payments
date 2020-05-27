//
//  SingleInputViewsController.swift
//  Example
//

final class SingleInputViewsController: BaseViewController<SingleInputView, SingleInputViewsModel> {
    /// - SeeAlso: BaseViewController.setupView
    override func setupView() {
        view.accessibilityIdentifier = "home/view/simpleInputViews"
        title = Localizable.SingleInputViewsController.title.text
    }

    /// - SeeAlso: BaseViewController.setupCallbacks
    override func setupCallbacks() {}

    /// - SeeAlso: BaseViewController.setupProperties
    override func setupProperties() {}
}

private extension Localizable {
    enum SingleInputViewsController: String, Localized {
        case title
    }
}
