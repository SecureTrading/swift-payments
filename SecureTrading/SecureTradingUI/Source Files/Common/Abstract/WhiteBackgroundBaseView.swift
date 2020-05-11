//
//  WhiteBackgroundBaseView.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 11/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

public class WhiteBackgroundBaseView: BaseView {
    /// Initialize an instance and sets background image
    override init() {
        super.init()
        backgroundColor = UIColor.white
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
