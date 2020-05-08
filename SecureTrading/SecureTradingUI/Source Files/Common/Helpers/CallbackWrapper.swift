//
//  CallbackWrapper.swift
//  SecureTradingUI
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import Foundation

final class CallbackWrapper {
    // MARK: Properties

    /// Closure
    private(set) var callback: (() -> Void)?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter callback: Closure which will be called by action.
    init(callback: (() -> Void)?) {
        self.callback = callback
    }

    // MARK: Functions

    /// Function which calls callback. Used by actions.
    @objc func callCallback() {
        callback?()
    }
}

