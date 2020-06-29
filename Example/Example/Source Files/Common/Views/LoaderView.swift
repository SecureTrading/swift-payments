//
//  LoaderView.swift
//  Example
//

import UIKit

/// A Simple loader view that consists of a grayed out square at the center of the screen with white UIActivity Indicator
class LoaderView: BaseView {

    // the actual spinner
    private var spinner = UIActivityIndicatorView(style: .whiteLarge)

    // center square container view
    private let spinnerContainerView = UIView(frame: .zero)

    // optional label at the bottom of container view
    private let label = UILabel()

    func start() {
        spinner.startAnimating()
    }
    func stop() {
        spinner.stopAnimating()
    }
}

extension LoaderView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupProperties
    func setupProperties() {
        // Spinner container
        spinnerContainerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        spinnerContainerView.layer.cornerRadius = 12
        spinnerContainerView.clipsToBounds = true

        // spinner
        spinner.hidesWhenStopped = true

        // label
        label.text = LocalizableKeys.Alerts.processing.localizedStringOrEmpty
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
    }

    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubview(spinnerContainerView)
        addSubview(spinner)
        addSubview(label)
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {
        // spinner container
        spinnerContainerView.addConstraints([
            equal(\.heightAnchor, greaterOrEqual: 150),
            equal(\.widthAnchor, greaterOrEqual: 150),
            equal(self, \.centerYAnchor, \.centerYAnchor, constant: 0),
            equal(self, \.centerXAnchor, \.centerXAnchor, constant: 0)
        ])

        // spinner
        spinner.addConstraints([
            equal(self, \.centerYAnchor, \.centerYAnchor, constant: 0),
            equal(self, \.centerXAnchor, \.centerXAnchor, constant: 0)
        ])

        // label
        label.addConstraints([
            equal(spinnerContainerView, \.bottomAnchor, \.bottomAnchor, constant: -10),
            equal(spinnerContainerView, \.centerXAnchor, \.centerXAnchor, constant: 0),
            equal(spinnerContainerView, \.leadingAnchor, \.leadingAnchor, constant: 5),
            equal(spinnerContainerView, \.trailingAnchor, \.trailingAnchor, constant: -5)
        ])
    }
}
