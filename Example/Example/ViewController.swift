//
//  ViewController.swift
//  Example
//
//  Created by TIWASZEK on 06/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import SecureTradingCore
import SecureTradingUI
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Test Core framework availability
        let apiClient = DefaultAPIClient()
        // Test UI framework availability
        let cardVC = CardViewController(view: CardView(), viewModel: CardViewModel())
    }
}
