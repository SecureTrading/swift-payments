//
//  TestView.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

// Provided example how to build views
@objc public final class TestView: BaseView {
    let testContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()

    let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

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

extension TestView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        testContainer.addSubview(testView)
        addSubviews([testContainer])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        testContainer.addConstraints(equalToSuperview(with: .init(top: 5, left: 5, bottom: -5, right: -5), usingSafeArea: true))

        testView.addConstraints([
            equal(testContainer, \.topAnchor, constant: 0),
            equal(testContainer, \.trailingAnchor, constant: 0)
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

