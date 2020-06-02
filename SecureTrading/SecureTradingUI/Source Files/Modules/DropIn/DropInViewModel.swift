//
//  DropInViewModel.swift
//  SecureTradingUI
//

#if !COCOAPODS
import SecureTradingCore
#endif
import Foundation

final class DropInViewModel {
    // MARK: Properties

    private let jwt: String

    /// - SeeAlso: SecureTradingCore.apiManager
    private let apiManager: APIManager

    // todo add card prefill

    var showAuthSuccess: ((ResponseSettleStatus) -> Void)?
    var showAuthError: ((String) -> Void)?

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameter apiManager: API manager
    init(jwt: String, gatewayType: GatewayType, username: String) {
        self.jwt = jwt
        self.apiManager = DefaultAPIManager(gatewayType: gatewayType, username: username)
    }

    // MARK: Functions

    func makeAuthCall() {

        // todo get card from fields

        let authRequest = RequestObject(typeDescriptions: [.auth])

        apiManager.makeGeneralRequest(jwt: jwt, request: authRequest, success: { [weak self] responseObject, _ in
            guard let self = self else { return }
            switch responseObject.responseErrorCode {
            case .successful:
                self.showAuthSuccess?(responseObject.responseSettleStatus)
            default:
                // transaction error
                self.showAuthError?(responseObject.errorMessage)
            }
        }, failure: { [weak self] error in
            guard let self = self else { return }
            // general APIClient error
            self.showAuthError?(error.humanReadableDescription)
        })
    }

    @discardableResult
    func validateForm(view: DropInView) -> Bool {
        let cardNumberValidationResult = view.cardNumberInput.validate(silent: false)
        let expiryDateValidationResult = view.expiryDateInput.validate(silent: false)
        let cvcValidationResult = view.cvcInput.validate(silent: false)
        return cardNumberValidationResult && expiryDateValidationResult && cvcValidationResult
    }
}
