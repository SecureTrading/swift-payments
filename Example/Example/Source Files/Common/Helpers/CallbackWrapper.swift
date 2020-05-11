//
//  CallbackWrapper.swift
//  SecureTradingUI
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

