//
//  MainView.swift
//  Example
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

final class MainView: BaseView {}

extension MainView: ViewSetupable {
    /// - SeeAlso: ViewSetupable.setupViewHierarchy
    func setupViewHierarchy() {
        addSubviews([])
    }

    /// - SeeAlso: ViewSetupable.setupConstraints
    func setupConstraints() {}
}

private extension Localizable {
}
