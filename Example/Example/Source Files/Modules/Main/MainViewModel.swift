//
//  MainViewModel.swift
//  Example
//

import Foundation
import SwiftJWT

protocol MainViewModelDataSource: class {
    func row(at index: IndexPath) -> MainViewModel.Row?
    func numberOfSections() -> Int
    func numberOfRows(at section: Int) -> Int
    func title(for section: Int) -> String?
    func detailInformationForRow(at index: IndexPath) -> String?
}

final class MainViewModel {
    // MARK: Properties

    /// Stores Sections and rows representing the main view
    fileprivate var items: [Section]

    private let paymentTransactionManager: PaymentTransactionManager

    /// Keys for certain scheme
    private let keys = ApplicationKeys(keys: ExampleKeys())

    var showAuthSuccess: ((ResponseSettleStatus) -> Void)?
    var showRequestSuccess: ((TypeDescription?) -> Void)?
    var showAuthError: ((String) -> Void)?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiManager: API manager
    /// - Parameter apiManager: API manager
    init(items: [Section]) {
        self.items = items
        self.paymentTransactionManager = PaymentTransactionManager(jwt: .empty, gatewayType: .eu, username: keys.merchantUsername, isLiveStatus: false, isDeferInit: true)
    }

    // MARK: Functions

    /// Returns JWT without card data as a String
    func getJwtTokenWithoutCardData(storeCard: Bool = false) -> String? {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1050,
                                              pan: nil,
                                              expirydate: nil,
                                              securitycode: nil,
                                              parenttransactionreference: nil,
                                              credentialsonfile: storeCard ? "1" : nil))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return nil }
        return jwt
    }

    /// Returns JWT with parent transaction reference
    func getJwtTokenWithParentTransactionReference() -> String? {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1050,
                                              pan: nil,
                                              expirydate: nil,
                                              securitycode: nil,
                                              parenttransactionreference: "59-9-34731"))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return nil }
        return jwt
    }

    /// Performs an AUTH request with card data
    func makeAuthCall() {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1100,
                                              pan: "4111111111111111",
                                              expirydate: "12/2022",
                                              securitycode: "123",
                                              parenttransactionreference: nil))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return }
        performTransaction(with: jwt, typeDescriptions: [.auth])
    }

    /// Performs Account check with card data
    func makeAccountCheckRequest() {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1100,
                                              pan: "4111111111111111",
                                              expirydate: "12/2022",
                                              securitycode: "123",
                                              parenttransactionreference: nil))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return }
        performTransaction(with: jwt, typeDescriptions: [.accountCheck])
    }

    /// Performs AUTH request without card data
    /// uses previous card reference
    func makeAccountCheckWithAuthRequest() {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1100,
                                              pan: nil,
                                              expirydate: nil,
                                              securitycode: nil,
                                              parenttransactionreference: "59-9-34731"))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return }
        performTransaction(with: jwt, typeDescriptions: [.accountCheck, .auth])
    }

    func performSubscriptionOnSTEngine() {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 199,
                                              pan: "4111111111111111",
                                              expirydate: "12/2022",
                                              securitycode: "123",
                                              subscriptiontype: "RECURRING",
                                              subscriptionfinalnumber: "12",
                                              subscriptionunit: "MONTH",
                                              subscriptionfrequency: "1",
                                              subscriptionnumber: "1"))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return }

        performTransaction(with: jwt, typeDescriptions: [.accountCheck, .subscription])
    }

    func performSubscriptionOnMerchantEngine() {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "RECUR",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 199,
                                              securitycode: "123",
                                              parenttransactionreference: "57-9-51718",
                                              subscriptiontype: "RECURRING",
                                              subscriptionnumber: "2"))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return }

        performTransaction(with: jwt, typeDescriptions: [.auth])
    }

    func payByCardFromParentReference() {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 199,
                                              securitycode: "123",
                                              parenttransactionreference: "59-9-99169"))

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return }

        performTransaction(with: jwt, typeDescriptions: [.threeDQuery, .auth])
    }

    func performTransaction(with jwt: String, typeDescriptions: [TypeDescription]) {
        paymentTransactionManager.performTransaction(jwt: jwt, typeDescriptions: typeDescriptions, card: nil, transactionSuccessClosure: { _, _ in
            self.showRequestSuccess?(nil)
        }, transactionErrorClosure: { _, errorMessage in
            self.showAuthError?(errorMessage)
        }, cardinalAuthenticationErrorClosure: {
            self.showAuthError?("An error occurred")
        }, validationErrorClosure: { error, _ in
            self.showAuthError?(error)
        })
    }
}

// MARK: MainViewModelDataSource

extension MainViewModel: MainViewModelDataSource {
    func row(at index: IndexPath) -> Row? {
        return items[index.section].rows[index.row]
    }

    func numberOfSections() -> Int {
        return items.count
    }

    func numberOfRows(at section: Int) -> Int {
        return items[section].rows.count
    }

    func title(for section: Int) -> String? {
        return items[section].title
    }

    func detailInformationForRow(at index: IndexPath) -> String? {
        return items[index.section].rows[index.row].detailInformation
    }
}

extension MainViewModel {
    enum Row {
        case testMainScreen
        case testMainFlow
        case performAuthRequestInBackground
        case presentSingleInputComponents
        case presentPayByCardForm
        case performAccountCheck
        case performAccountCheckWithAuth
        case presentAddCardForm
        case presentWalletForm
        case showDropInControllerWithCustomView
        case showDropInControllerWithWarnings
        case showDropInControllerNo3DSecure
        case payByCardFromParentReference
        case subscriptionOnSTEngine
        case subscriptionOnMerchantEngine

        var title: String {
            switch self {
            case .testMainScreen:
                return Localizable.MainViewModel.showTestMainScreenButton.text
            case .testMainFlow:
                return Localizable.MainViewModel.showTestMainFlowButton.text
            case .performAuthRequestInBackground:
                return Localizable.MainViewModel.makeAuthRequestButton.text
            case .presentSingleInputComponents:
                return Localizable.MainViewModel.showSingleInputViewsButton.text
            case .presentPayByCardForm:
                return Localizable.MainViewModel.showDropInControllerButton.text
            case .performAccountCheck:
                return Localizable.MainViewModel.makeAccountCheckRequestButton.text
            case .performAccountCheckWithAuth:
                return Localizable.MainViewModel.makeAccountCheckWithAuthRequestButton.text
            case .presentAddCardForm:
                return Localizable.MainViewModel.addCardReferenceButton.text
            case .presentWalletForm:
                return Localizable.MainViewModel.payWithWalletButton.text
            case .showDropInControllerWithWarnings:
                return Localizable.MainViewModel.showDropInControllerWithWarningsButton.text
            case .subscriptionOnSTEngine:
                return Localizable.MainViewModel.subscriptionOnSTEngine.text
            case .subscriptionOnMerchantEngine:
                return Localizable.MainViewModel.subscriptionOnMerchantEngine.text
            case .showDropInControllerNo3DSecure:
                return Localizable.MainViewModel.showDropInControllerNo3DSecure.text
            case .showDropInControllerWithCustomView:
                return Localizable.MainViewModel.showDropInControllerWithCustomView.text
            case .payByCardFromParentReference:
                return Localizable.MainViewModel.payByCardFromParentReference.text
            }
        }

        var hasDetailedInfo: Bool {
            return detailInformation != nil
        }

        var detailInformation: String? {
            switch self {
            case .testMainScreen:
                return nil
            case .testMainFlow:
                return nil
            case .performAuthRequestInBackground:
                return """
                Performs AUTH request to the EU gateway:

                accounttypedescription: "ECOM"
                currencyiso3a: "GBP"
                baseamount: 1100
                pan: "4111111111111111"
                expirydate: "12/2022"
                securitycode: "123"
                """
            case .presentSingleInputComponents:
                return nil
            case .presentPayByCardForm:
                return nil
            case .performAccountCheck:
                return nil
            case .performAccountCheckWithAuth:
                return nil
            case .presentAddCardForm:
                return nil
            case .presentWalletForm:
                return nil
            case .showDropInControllerWithWarnings:
                return nil
            case .subscriptionOnSTEngine:
                return """
                Performs ACCOUNTCHECK & SUBSCRIPTION request to the EU gateway:

                accounttypedescription: "ECOM"
                currencyiso3a: "GBP"
                baseamount: 199
                pan: "4111111111111111"
                expirydate: "12/2022"
                securitycode: "123"
                subscriptiontype: "RECURRING"
                subscriptionfinalnumber: "12"
                subscriptionunit: "MONTH"
                subscriptionfrequency: "1"
                subscriptionnumber: "1"
                """
            case .subscriptionOnMerchantEngine:
                return """
                Performs AUTH request to the EU gateway:

                accounttypedescription: "RECUR"
                currencyiso3a: "GBP"
                baseamount: 199
                securitycode: "123"
                parenttransactionreference: "58-9-53270"
                subscriptiontype: "RECURRING"
                subscriptionnumber: "2"

                Make sure the parent transaction is valid
                """
            case .showDropInControllerNo3DSecure:
                return nil
            case .showDropInControllerWithCustomView:
                return nil
            case .payByCardFromParentReference:
                return nil
            }
        }
    }

    enum Section {
        case onMerchant(rows: [Row])
        case onSDK(rows: [Row])

        var rows: [Row] {
            switch self {
            case .onMerchant(let rows): return rows
            case .onSDK(let rows): return rows
            }
        }

        var title: String? {
            switch self {
            case .onMerchant: return Localizable.MainViewModel.merchantResponsibility.text
            case .onSDK: return Localizable.MainViewModel.sdkResponsibility.text
            }
        }
    }
}

// MARK: Translations

private extension Localizable {
    enum MainViewModel: String, Localized {
        case showTestMainScreenButton
        case showTestMainFlowButton
        case makeAuthRequestButton
        case showSingleInputViewsButton
        case showDropInControllerButton
        case showDropInControllerWithWarningsButton
        case makeAccountCheckRequestButton
        case makeAccountCheckWithAuthRequestButton
        case addCardReferenceButton
        case payWithWalletButton
        case merchantResponsibility
        case sdkResponsibility
        case showDropInControllerNo3DSecure
        case showDropInControllerWithCustomView
        case subscriptionOnSTEngine
        case subscriptionOnMerchantEngine
        case payByCardFromParentReference
    }
}
