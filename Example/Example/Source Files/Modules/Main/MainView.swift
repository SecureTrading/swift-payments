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
        button.setTitle("show test main screen (from SecureTradingUI)", for: .normal)
        return button
    }()

    private let showTestMainFlowButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = Fonts.responsive(.medium, ofSizes: [.small: 13, .medium: 14, .large: 16])
        button.setTitle("show test main flow (from SecureTradingUI)", for: .normal)
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
        stackView.addConstraints(equalToSuperview(with: .init(top: 5, left: 5, bottom: -5, right: -5), usingSafeArea: true))
    }
}

private extension Localizable {}
