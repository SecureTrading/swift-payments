//
//  ViewSetupable.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

/// Interface for setting up the view
protocol ViewSetupable {
    /// Add subviews to the view when called
    func setupViewHierarchy()

    /// Add constraints to the view when called
    func setupConstraints()

    /// Setup required properties when called
    func setupProperties()
}

extension ViewSetupable {
    // Empty default implementation - not every class need this method
    func setupProperties() {}

    /// Calls all other setup methods in proper order
    func setupView() {
        setupViewHierarchy()
        setupConstraints()
        setupProperties()
    }
}
