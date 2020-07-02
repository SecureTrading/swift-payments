//
//  ViewController.swift
//  CarthageTest
//
//  Created by TIWASZEK on 08/05/2020.
//  Copyright © 2020 TIWASZEK. All rights reserved.
//

import SecureTrading3DSecure
import SecureTradingCard
import SecureTradingCore
import SecureTradingUI
import UIKit

class ViewController: UIViewController {
    var dropInVC: DropInController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Test UI framework availability
        let testMainVC = ViewControllerFactory.shared.testMainViewController {}

        // swiftlint:disable line_length
        let inputViewStyleManager = InputViewStyleManager(titleColor: UIColor.gray, textFieldBorderColor: UIColor.black.withAlphaComponent(0.8), textFieldBackgroundColor: .clear, textColor: .black, placeholderColor: UIColor.lightGray.withAlphaComponent(0.8), errorColor: UIColor.red.withAlphaComponent(0.8), titleFont: UIFont.systemFont(ofSize: 16, weight: .regular), textFont: UIFont.systemFont(ofSize: 16, weight: .regular), placeholderFont: UIFont.systemFont(ofSize: 16, weight: .regular), errorFont: UIFont.systemFont(ofSize: 12, weight: .regular), textFieldImage: nil, titleSpacing: 5, errorSpacing: 3, textFieldHeightMargins: HeightMargins(top: 10, bottom: 10), textFieldBorderWidth: 1, textFieldCornerRadius: 6)

        let payButtonStyleManager = PayButtonStyleManager(titleColor: .white, enabledBackgroundColor: .black, disabledBackgroundColor: UIColor.lightGray.withAlphaComponent(0.6), borderColor: .clear, titleFont: UIFont.systemFont(ofSize: 16, weight: .medium), spinnerStyle: .white, spinnerColor: .white, buttonContentHeightMargins: HeightMargins(top: 15, bottom: 15), borderWidth: 0, cornerRadius: 6)

        let dropInViewStyleManager = DropInViewStyleManager(inputViewStyleManager: inputViewStyleManager, requestButtonStyleManager: payButtonStyleManager, backgroundColor: .white, spacingBeetwenInputViews: 25, insets: UIEdgeInsets(top: 25, left: 35, bottom: -30, right: -35))
        // swiftlint:disable line_length

        dropInVC = ViewControllerFactory.shared.dropInViewController(jwt: "", typeDescriptions: [.threeDQuery, .auth], gatewayType: .eu, username: "", isLiveStatus: false, isDeferInit: false, customDropInView: nil, visibleFields: [.securityCode3], dropInViewStyleManager: dropInViewStyleManager, cardTypeToBypass: [], cardinalStyleManager: nil, cardinalDarkModeStyleManager: nil, payButtonTappedClosureBeforeTransaction: { [unowned self] controller in

        }, successfulPaymentCompletion: { [unowned self] _, successMessage, cardReference in

        }, transactionFailure: { [unowned self] _, errorMessage in

        }, cardinalWarningsCompletion: { [unowned self] warningsMessage, _ in

        })

        navigationController?.present(dropInVC.viewController, animated: false, completion: nil)
    }
}
