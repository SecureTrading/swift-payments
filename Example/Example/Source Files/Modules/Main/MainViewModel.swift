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
}

final class MainViewModel {
    // MARK: Properties

    /// Stores Sections and rows representing the main view
    fileprivate var items: [Section]

    /// - SeeAlso: AppFoundation.apiManager
    private let apiManager: APIManager

    /// Keys for certain scheme
    private let keys = ApplicationKeys(keys: ExampleKeys())

    var showAuthSuccess: ((ResponseSettleStatus) -> Void)?
    var showRequestSuccess: ((TypeDescription?) -> Void)?
    var showAuthError: ((String) -> Void)?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiManager: API manager
    init(apiManager: APIManager, items: [Section]) {
        self.apiManager = apiManager
        self.items = items
    }

    // MARK: Functions

    /// Returns JWT without card data as a String
    func getJwtTokenWithoutCardData() -> String? {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1050,
                                              pan: nil,
                                              expirydate: nil,
                                              securitycode: nil,
                                              parenttransactionreference: nil))

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
        let authRequest = RequestObject(typeDescriptions: [.auth])
        makeRequest(with: jwt, request: authRequest)
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
        let authRequest = RequestObject(typeDescriptions: [.accountCheck])
        makeRequest(with: jwt, request: authRequest)
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
                                              parenttransactionreference: "59-9-34731")
        )

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return }
        let authRequest = RequestObject(typeDescriptions: [.accountCheck, .auth])
        makeRequest(with: jwt, request: authRequest)
    }

    private func makeRequest(with jwt: String, request: RequestObject) {
        apiManager.makeGeneralRequest(jwt: jwt, request: request, success: { [weak self] responseObject, _ in
            guard let self = self else { return }
            switch responseObject.responseErrorCode {
            case .successful:
                self.showRequestSuccess?(nil)
            default:
                // transaction error
                self.showAuthError?(responseObject.errorMessage)
            }
            }, failure: { [weak self] error in
                guard let self = self else { return }
                switch error {
                case .responseValidationError(let responseError):
                    switch responseError {
                    case .invalidField(let errorCode):
                        var message = "Invalid field: "
                        switch errorCode {
                        case .invalidPAN: message += "PAN"
                        case .invalidSecurityCode: message += "Security code"
                        case .invalidJWT: message += "JWT"
                        case .invalidExpiryDate: message += "Expiry date"
                        case .invalidTermURL: message += "Terms URL"
                        case .invalidParentTransactionReference: message += "Parent transaction reference"
                        case .invalidSiteReference: message += "Invalid site reference value"
                        case .none: message += ""
                        }
                        // Update UI
                        self.showAuthError?(message)
                    default:
                        self.showAuthError?(error.humanReadableDescription)
                    }
                default:
                    self.showAuthError?(error.humanReadableDescription)
                }
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
        case showDropInControllerWithWarnings

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
fileprivate extension Localizable {
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
    }
}
