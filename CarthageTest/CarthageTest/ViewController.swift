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
import SecureTrading3DSecure
import SecureTradingCard

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Test UI framework availability
        let testMainVC = ViewControllerFactory.shared.testMainViewController {}
    }

}
