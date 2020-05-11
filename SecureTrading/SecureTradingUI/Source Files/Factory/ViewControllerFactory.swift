//
//  ViewControllerFactory.swift
//  SecureTradingUI
//

import Foundation
import UIKit

@objc public final class ViewControllerFactory: NSObject {

    @objc public static let shared = ViewControllerFactory()

    private let viewModelFactory = ViewModelFactory()

    private override init() {}

    @objc public func testMainViewController() -> UIViewController {
        let viewController = TestMainViewController(view: TestMainView(), viewModel: viewModelFactory.testMainViewModel())
        return viewController
    }
}
