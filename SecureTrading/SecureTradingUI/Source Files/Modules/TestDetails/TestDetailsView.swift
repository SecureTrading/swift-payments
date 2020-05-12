//
//  TestDetailsView.swift
//  SecureTradingUI
//

import UIKit

// Provided example how to build views
final class TestDetailsView: WhiteBackgroundBaseView {}

extension TestDetailsView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {}
}
