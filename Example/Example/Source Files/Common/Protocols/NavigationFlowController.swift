//
//  NavigationFlowController.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

protocol NavigationFlowController: FlowController {
    var navigationController: UINavigationController { get }
    var childFlowController: FlowController? { get }
}

extension NavigationFlowController {
    var rootViewController: UIViewController? {
        return navigationController
    }
}
