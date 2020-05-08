//
//  BaseFlowController.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

class BaseFlowController: NSObject, FlowController {
    // MARK: Properties

    /// Flow controller root view controller.
    var rootViewController: UIViewController?

    /// An object which is responsible for navigation.
    weak var navigationDelegate: NavigationDelegate?
}
