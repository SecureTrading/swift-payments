//
//  AppDelegate.swift
//  Example
//

import UIKit
import SwiftJWT

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    /// - SeeAlso: UIApplicationDelegate.window
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    /// Application's foundation.
    /// Keeps dependencies in the same place and allow to reuse them across entire application
    /// without necessity to have multiple instances of one class which should be unique.
    private let appFoundation = DefaultAppFoundation()

    // Application main flow controller
    private lazy var appFlowController = AppFlowController(appFoundation: appFoundation, window: window!)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        TrustPayments.instance.configure(locale: Locale(identifier: "pl_PL"), translationsForOverride:
            [
                Locale(identifier: "fr_FR"):
                    [
                        LocalizableKeys.PayButton.title.key: "Payez maintenant!",
                        LocalizableKeys.Navigation.back.key: "Retourner"
                ],
                Locale(identifier: "en_GB"):
                    [
                        LocalizableKeys.PayButton.title.key: "Pay Now!",
                        LocalizableKeys.Navigation.back.key: "Go back"
                ],
                Locale(identifier: "it_IT"):
                    [
                        LocalizableKeys.PayButton.title.key: "Paga ora!",
                        LocalizableKeys.Navigation.back.key: "Torna indietro"
                ],
                Locale(identifier: "pl_PL"):
                    [
                        LocalizableKeys.PayButton.title.key: "Zapłac",
                        LocalizableKeys.Navigation.back.key: "wstecz"
                ]
            ]
        )
        appFlowController.start()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}
}
