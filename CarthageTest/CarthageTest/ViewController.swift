//
//  ViewController.swift
//  CarthageTest
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit
import SecureTradingUI
import SecureTradingCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Test Core framework availability
        let apiClient = DefaultAPIClient()
        // Test UI framework availability
        let testMainVC = ViewControllerFactory.shared.testMainViewController
    }


}

