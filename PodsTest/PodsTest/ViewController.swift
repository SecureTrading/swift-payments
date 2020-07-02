//
//  ViewController.swift
//  PodsTest
//

import SecureTradingSDK
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Test UI framework availability
        let testMainVC = ViewControllerFactory.shared.testMainViewController {}
    }
}
