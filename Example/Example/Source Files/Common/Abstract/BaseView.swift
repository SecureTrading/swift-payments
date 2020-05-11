//
//  BaseView.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import UIKit

public class BaseView: UIView {
    /// Indicating if keyboard should be closed on touch
    var closeKeyboardOnTouch = true

    /// Initialize an instance and calls required methods
    init() {
        super.init(frame: .zero)
        guard let setupableView = self as? ViewSetupable else { return }
        setupableView.setupView()
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// - SeeAlso: UIView.touchesBegan()
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if closeKeyboardOnTouch {
            endEditing(true)
        }
    }
}
