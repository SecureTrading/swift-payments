//
//  MainView.swift
//  Example
//

import UIKit

final class MainView: WhiteBackgroundBaseView {
    var showTestMainScreenButtonTappedClosure: (() -> Void)? {
        get { return showTestMainScreenButton.onTap }
        set { showTestMainScreenButton.onTap = newValue }
    }

    var showTestMainFlowButtonTappedClosure: (() -> Void)? {
        get { return showTestMainFlowButton.onTap }
        set { showTestMainFlowButton.onTap = newValue }
    }

    var makeAuthRequestButtonTappedClosure: (() -> Void)? {
        get { return makeAuthRequestButton.onTap }
        set { makeAuthRequestButton.onTap = newValue }
    }

    var showSingleInputViewsButtonTappedClosure: (() -> Void)? {
        get { return showSingleInputViewsButton.onTap }
        set { showSingleInputViewsButton.onTap = newValue }
    }

    var showDropInControllerButtonTappedClosure: (() -> Void)? {
        get { return showDropInControllerButton.onTap }
        set { showDropInControllerButton.onTap = newValue }
    }

    var accountCheckRequest: (() -> Void)? {
        get { return makeAccountCheckRequestButton.onTap }
        set { makeAccountCheckRequestButton.onTap = newValue }
    }

    var accountCheckWithAuthRequest: (() -> Void)? {
        get { return makeAccountCheckWithAuthRequestButton.onTap }
        set { makeAccountCheckWithAuthRequestButton.onTap = newValue }
    }

    private let makeAuthRequestButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        button.setTitle(Localizable.MainView.makeAuthRequestButton.text, for: .normal)
        return button
    }()

    private let showTestMainScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        button.setTitle(Localizable.MainView.showTestMainScreenButton.text, for: .normal)
        return button
    }()

    private let showTestMainFlowButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        button.setTitle(Localizable.MainView.showTestMainFlowButton.text, for: .normal)
        return button
    }()

    private let showSingleInputViewsButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        button.setTitle(Localizable.MainView.showSingleInputViewsButton.text, for: .normal)
        return button
    }()

    private let showDropInControllerButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        button.setTitle(Localizable.MainView.showDropInControllerButton.text, for: .normal)
        return button
    }()

    private let makeAccountCheckRequestButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        button.setTitle(Localizable.MainView.makeAccountCheckRequestButton.text, for: .normal)
        return button
    }()

    private let makeAccountCheckWithAuthRequestButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        button.setTitle(Localizable.MainView.makeAccountCheckWithAuthRequestButton.text, for: .normal)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [showTestMainScreenButton,
                                                       showTestMainFlowButton,
                                                       makeAuthRequestButton,
                                                       showSingleInputViewsButton,
                                                       showDropInControllerButton,
                                                       makeAccountCheckRequestButton,
                                                       makeAccountCheckWithAuthRequestButton])
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
}

extension MainView: ViewSetupable {
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

private extension Localizable {
    enum MainView: String, Localized {
        case showTestMainScreenButton
        case showTestMainFlowButton
        case makeAuthRequestButton
        case showSingleInputViewsButton
        case showDropInControllerButton
        case makeAccountCheckRequestButton
        case makeAccountCheckWithAuthRequestButton
    }
}
