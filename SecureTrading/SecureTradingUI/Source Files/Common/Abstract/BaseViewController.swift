//
//  BaseViewController.swift
//  SecureTradingUI
//

import UIKit

public class BaseViewController<View: ViewProtocol, ViewModel>: UIViewController {
    /// Custom view of view controller.
    let customView: View

    /// View model of view controller.
    let viewModel: ViewModel

    /// - SeeAlso: UIViewController.preferredStatusBarStyle
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    /// Initializes view controller with given View.
    ///
    /// - Parameter view: Maker for the UIView.
    init(view: @escaping @autoclosure () -> View, viewModel: ViewModel) {
        customView = view()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    /// - SeeAlso: NSCoding.init?(coder:)
    @available(*, unavailable, message: "Not available, use init(view:viewModel)")
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// - SeeAlso: UIViewController.loadView()
    public override func loadView() {
        view = customView
    }

    /// - SeeAlso: UIViewController.viewDidLoad()
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupProperties()
        setupBehaviour()
        setupCallbacks()
    }

    deinit {
        #if DEBUG
            print("Deinited \(self)")
        #endif
    }

    /// Sets up the properties of `self`. Called automatically on `viewDidLoad()`.
    func setupProperties() {
        // no-op by default
    }

    /// Sets up view in `self`. Called automatically on `viewDidLoad()`.
    func setupView() {
        // no-op by default
    }

    /// Sets up behaviour in `self`. Called automatically on `viewDidLoad()`.
    func setupBehaviour() {
        // no-op by default
    }

    /// Sets up callbacks in `self`. Called automatically on `viewDidLoad()`.
    func setupCallbacks() {
        // no-op by default
    }
}
