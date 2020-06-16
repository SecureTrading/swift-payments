//
//  ST3DSecureManager.swift
//  SecureTrading3DSecure
//

import CardinalMobile
import Foundation

@objc public enum CardinalInitWarnings: Int {
    case jailbroken
    case integrityTampered
    case emulatorBeingUsed
    case debuggerAttached
    case osNotSupported
    case appFromNotTrustedSource

    public var localizedDescription: String {
        switch self {
        case .jailbroken:
            return "jailbroken"
        case .integrityTampered:
            return "integrity tampered"
        case .emulatorBeingUsed:
            return "emulator being used"
        case .debuggerAttached:
            return "debugger attached"
        case .osNotSupported:
            return "os not supported"
        case .appFromNotTrustedSource:
            return "app from not trusted source"
        }
    }
}

/// Base manager for dealing with 3D secure challenges via Cardinal Commerce SDK
public final class ST3DSecureManager {
    // MARK: - Private properties

    private let session: CardinalSession

    private let isLiveStatus: Bool

    // MARK: - Public properties

    /// get a list of all the Warnings detected by the SDK
    public var warnings: [CardinalInitWarnings] {
        let warnings = session.getWarnings()
        var cardinalWarnings: [CardinalInitWarnings] = []

        // The device is jailbroken.
        if warnings.first(where: { $0.warningID == "SW01" }) != nil {
            cardinalWarnings.append(.jailbroken)
        }

        // The integrity of the SDK has tampered.
        if warnings.first(where: { $0.warningID == "SW02" }) != nil {
            cardinalWarnings.append(.integrityTampered)
        }

        // An emulator is being used to run the App.
        if warnings.first(where: { $0.warningID == "SW03" }) != nil {
            cardinalWarnings.append(.emulatorBeingUsed)
        }

        // A debugger is attached to the App.
        if warnings.first(where: { $0.warningID == "SW04" }) != nil {
            cardinalWarnings.append(.debuggerAttached)
        }

        // The OS or the OS version is not supported.
        if warnings.first(where: { $0.warningID == "SW05" }) != nil {
            cardinalWarnings.append(.osNotSupported)
        }

        // The application is not installed from a trusted source.
        if warnings.first(where: { $0.warningID == "SW06" }) != nil {
            cardinalWarnings.append(.appFromNotTrustedSource)
        }

        return cardinalWarnings
    }

    // MARK: - Public initializers

    /// Initializes an instance of the receiver
    /// - Parameter isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment)
    public init(isLiveStatus: Bool) {
        self.isLiveStatus = isLiveStatus
        self.session = CardinalSession()
        configure()
    }

    // MARK: - Private methods

    /// Configure session with env type, timeouts and UI
    private func configure() {
        let config = CardinalSessionConfiguration()
        config.deploymentEnvironment = isLiveStatus ? .production : .staging
        config.requestTimeout = 8000
        config.challengeTimeout = 8
        config.uiType = .both // possible native and html

        // todo - ui customization
        let yourCustomUi = UiCustomization()
        // Set various customizations here. See "iOS UI Customization" documentation for detail.
        config.uiCustomization = yourCustomUi

        config.renderType = [CardinalSessionRenderTypeOTP,
                             CardinalSessionRenderTypeHTML,
                             CardinalSessionRenderTypeOOB,
                             CardinalSessionRenderTypeSingleSelect,
                             CardinalSessionRenderTypeMultiSelect]

        // configure session
        session.configure(config)
    }

    // MARK: - Public methods

    /// Authenticating merchant's credentials (jwt) and completing the data collection process
    /// - Parameters:
    ///   - jwt: JWT provided by ST in response to JSINIT request
    ///   - cardNumber: parameter passed when the consumer has already entered card number, e.g. in case of JS defer init
    ///   - completion: success closure with following parameters: consumer session id
    ///   - failure: if there was an error with setup, cardinal will call this closure with validate response object
    public func setup(with jwt: String, cardNumber: String? = nil, completion: @escaping ((String) -> Void), failure: @escaping ((CardinalResponse) -> Void)) {
        guard let cardNumber = cardNumber else {
            session.setup(jwtString: jwt, completed: { consumerSessionId in
                completion(consumerSessionId)
            }, validated: { validateResponse in
                failure(validateResponse)
            })
            return
        }

        session.setup(jwtString: jwt, account: cardNumber, completed: { consumerSessionId in
            // You may have your Submit button disabled on page load. Once you are setup
            // for CCA, you may then enable it. This will prevent users from submitting
            // their order before CCA is ready.
            completion(consumerSessionId)
        }, validated: { validateResponse in
            // Handle failed setup
            // If there was an error with setup, cardinal will call this function with
            // validate response and empty serverJWT
            failure(validateResponse)
        })
    }
}
