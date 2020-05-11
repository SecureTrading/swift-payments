//
//  TestView.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

// Provided example how to build views
public final class TestMainView: WhiteBackgroundBaseView {
    /// Closure invoked when someone taps on show details button.
    var showDetailsButtonTappedClosure: (() -> Void)? {
        get { return showDetailsButton.onTap }
        set { showDetailsButton.onTap = newValue }
    }

    // MARK: Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = Fonts.responsive(.bold, ofSizes: [.small: 17, .medium: 18, .large: 20])
        label.numberOfLines = 1
        label.text = Localizable.TestMainView.titleLabel.text
        return label
    }()

    private var showDetailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localizable.TestMainView.showDetailsButton.text, for: .normal)
        button.titleLabel?.font = Fonts.responsive(.regular, ofSizes: [.small: 13, .medium: 14, .large: 16])
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, showDetailsButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    private let testContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.testContainerBackground
        return view
    }()

    private let testView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.testViewBackground
        return view
    }()

    // other examples

//    private lazy var statisticsStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [statisticsLabel, checkmarkImageView])
//        stackView.axis = .horizontal
//        stackView.spacing = 5
//        stackView.alignment = .fill
//        stackView.distribution = .fill
//        stackView.isHidden = true
//        return stackView
//    }()
//
//    private lazy var mainStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [wonTitleLabel, badgeImageContainerView, titleLabel, descriptionLabel, statisticsStackView])
//        stackView.axis = .vertical
//        stackView.spacing = 30
//        stackView.alignment = .center
//        stackView.distribution = .fill
//        stackView.layoutMargins = UIEdgeInsets(top: mainStackMargin, left: mainStackMargin, bottom: mainStackMargin, right: mainStackMargin)
//        stackView.isLayoutMarginsRelativeArrangement = true
//        return stackView
//    }()
}

extension TestMainView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        testContainer.addSubview(testView)
        testContainer.addSubview(stackView)
        addSubviews([testContainer])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        testContainer.addConstraints(equalToSuperview(with: .init(top: 5, left: 5, bottom: -5, right: -5), usingSafeArea: true))

        testView.addConstraints([
            equal(testContainer, \.topAnchor, constant: 0),
            equal(testContainer, \.trailingAnchor, constant: 0),
            equal(\.heightAnchor, to: 150),
            equal(\.widthAnchor, to: 150)
        ])

        stackView.addConstraints([
            equal(testContainer, \.centerYAnchor),
            equal(testContainer, \.centerXAnchor)
        ])

        // other examples

//        circularProgressbarContainerView.addConstraints([
//            equal(\.heightAnchor, greaterOrEqual: 150)
//        ])
//
//        circularProgressbar.addConstraints([
//            equal(circularProgressbarContainerView, \.centerYAnchor),
//            equal(circularProgressbarContainerView, \.trailingAnchor),
//            equal(circularProgressbarContainerView, \.leadingAnchor),
//            equal(\.heightAnchor, to: 150),
//            equal(\.widthAnchor, to: 150)
//        ])
//
//        scrollView.addConstraints([
//            equal(self, \.topAnchor, \.safeAreaLayoutGuide.topAnchor, constant: 0),
//            equal(self, \.bottomAnchor, \.safeAreaLayoutGuide.bottomAnchor, constant: 0)
//        ])
//
//        badgeImageView.addConstraints([
//            equal(self, \.heightAnchor, to: \.heightAnchor, constant: 0.0, multiplier: 0.35),
//            equal(badgeImageView, \.heightAnchor, to: \.widthAnchor, constant: 0.0, multiplier: 1)
//        ])
    }
}

private extension Localizable {
    enum TestMainView: String, Localized {
        case titleLabel
        case showDetailsButton
    }
}
