//
//  MainView.swift
//  Example
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
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

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [showTestMainScreenButton, showTestMainFlowButton])
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
       }
}
