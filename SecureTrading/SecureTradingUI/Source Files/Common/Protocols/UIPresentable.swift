//
//  UIPresentable.swift
//  SecureTradingUI
//

import UIKit

// Default implementation returning `self` as `UIViewController`.
extension UIPresentable where Self: UIViewController {
    var viewController: UIViewController {
        return self
    }
}

/// Specifies behaviour of an object presentable within the application UI.
@objc public protocol UIPresentable: class {
    /// View controller to be added to the UI hierarchy.
    @objc var viewController: UIViewController { get }
}
