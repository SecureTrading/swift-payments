//
//  ST3DSecureManager.swift
//  SecureTrading3DSecure
//

import CardinalMobile
import Foundation

/// Base manager for dealing with 3D secure challenges via Cardinal Commerce SDK
public final class ST3DSecureManager {
    // MARK: - Private properties

    private let session: CardinalSession

    private let isLiveStatus: Bool

    // MARK: - Public proprties

    public var warrnings: [Warning] {
        return session.getWarnings()
    }

    // MARK: - Public initializers

    /// Initializes an instance of the receiver
    /// - Parameter isLiveStatus: this instructs whether the 3-D Secure checks are performed using the test environment or production environment (if false 3-D Secure checks are performed using the test environment)
    public init(isLiveStatus: Bool) {
        self.isLiveStatus = isLiveStatus
        self.session = CardinalSession()
    }

    // MARK: - Public methods

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

    public func setup(with jwt: String, cardNumber: String) {
        // JWT provided by ST in response to JSINIT request
        // TODO: session setup
    }
}
