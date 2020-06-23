//
//  WalletViewModel.swift
//  Example
//

import Foundation

protocol WalletViewModelDataSource: class {
    func row(at index: IndexPath) -> WalletViewModel.Row
    func numberOfSections() -> Int
    func numberOfRows(at section: Int) -> Int
    func title(for section: Int) -> String?
    func section(at section: Int) -> WalletViewModel.Section
}

final class WalletViewModel {
    /// - SeeAlso: AppFoundation.apiManager
    private let apiManager: APIManager

    /// Keys for certain scheme
    private let keys = ApplicationKeys(keys: ExampleKeys())

    // Stores items on presented on list
    private var items: [Section] = []

    /// Stores temporary selected card reference
    private var selectedCard: STCardReference?

    /// Callbacks
    var showRequestSuccess: ((TypeDescription?) -> Void)?
    var showAuthError: ((String) -> Void)?

    /// Returns merchant user name without exposing Keys object
    var getUsername: String {
        return keys.merchantUsername
    }

    /// - Parameter apiManager: API manager
    init(apiManager: APIManager, items: [Section]) {
        self.apiManager = apiManager
        self.items = items
    }

    /// Updates list items
    func addNewCard(_ card: STCardReference?) {
        guard let newCard = card else { return }
        if let index = items.firstIndex(where: {$0.title == Section.paymentMethods(rows: []).title}) {
            var newRows = items[index].rows
            newRows.append(Row.cardReference(newCard))
            items[index] = Section.paymentMethods(rows: newRows)
            if let nextIndex = items.firstIndex(where: {$0.title == Section.addMethod(showHeader: false, rows: []).title}) {
                let nextRows = items[nextIndex].rows
                items[nextIndex] = Section.addMethod(showHeader: newRows.isEmpty ? false : true, rows: nextRows)
            }
        }
    }
    /// Called to store a reference for currently selected card on Wallet list
    /// - Parameter card: STCardReference object
    func cardSelected(_ card: STCardReference) {
        selectedCard = card
    }

    /// Performs an Auth request with selected card reference if selected card exists
    func performAuthRequest() {
        if let card = selectedCard {
            performAuthRequest(with: card)
        }
    }

    /// Return JWT containing all data needed for AUTH request except card information
    /// - Returns: JWT as String
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

    /// Performs an Auth request with parent transaction reference, based on previously used card
    /// - Parameter card: STCardReference object
    private func performAuthRequest(with card: STCardReference) {
        let claim = STClaims(iss: keys.merchantUsername,
                             iat: Date(timeIntervalSinceNow: 0),
                             payload: Payload(accounttypedescription: "ECOM",
                                              sitereference: keys.merchantSiteReference,
                                              currencyiso3a: "GBP",
                                              baseamount: 1100,
                                              pan: nil,
                                              expirydate: nil,
                                              securitycode: nil,
                                              parenttransactionreference: card.transactionReference)
        )

        guard let jwt = JWTHelper.createJWT(basedOn: claim, signWith: keys.jwtSecretKey) else { return }
        let authRequest = RequestObject(typeDescriptions: [.auth])
        makeRequest(with: jwt, request: authRequest)
    }

    private func makeRequest(with jwt: String, request: RequestObject) {
        apiManager.makeGeneralRequest(jwt: jwt, request: request, success: { [weak self] responseObject, _, _ in
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
                    case .invalidField:
                        // Update UI
                        self.showAuthError?(responseError.localizedDescription)
                    default:
                        self.showAuthError?(error.humanReadableDescription)
                    }
                default:
                    self.showAuthError?(error.humanReadableDescription)
                }
        })
    }
}

extension WalletViewModel: WalletViewModelDataSource {
    func row(at index: IndexPath) -> Row {
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
    func section(at section: Int) -> Section {
        return items[section]
    }
}

extension WalletViewModel {
    enum Row {
        case cardReference(STCardReference)
        case addCard(title: String)

        var card: STCardReference? {
            switch self {
            case .cardReference(let cardRef): return cardRef
            case .addCard: return nil
            }
        }
    }
    enum Section {
        case paymentMethods(rows: [Row])
        case addMethod(showHeader: Bool, rows: [Row])

        var rows: [Row] {
            switch self {
            case .paymentMethods(let rows): return rows
            case .addMethod(_, let rows): return rows
            }
        }
        var title: String? {
            switch self {
            case .paymentMethods: return Localizable.WalletViewModel.paymentMethods.text
            case .addMethod(let showHeader, _): return showHeader ? Localizable.WalletViewModel.infoText.text : nil
            }
        }
    }
}

private extension Localizable {
    enum WalletViewModel: String, Localized {
        case paymentMethods
        case infoText
    }
}
