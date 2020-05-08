//
//  ViewController.swift
//  PodsTest
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit
import SecureTradingSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cardModel = CardViewModel()
        let apiClient = DefaultAPIClient()
    }


}

