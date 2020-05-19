//
//  ST3DSecureManager.swift
//  SecureTrading3DSecure
//

import Foundation
import CardinalMobile

/// Base manager for dealing with 3D secure challenges via Cardinal Commerce SDK
public final class ST3DSecureManager {
    
    // MARK: - Private properties
    private let session: CardinalSession
    
    // MARK: - Public proprties
    public var warrnings: [Warning] {
        return self.session.getWarnings()
    }
    
    // MARK: - Public initializers
    public init() {
        self.session = CardinalSession()
    }
    
    // MARK: - Public methods
    /// Configure session with env type, timeouts and UI
    public func configure() {
        // TODO:
        let config = CardinalSessionConfiguration()
        config.deploymentEnvironment = .staging
        config.requestTimeout = 8000
        config.challengeTimeout = 8
        config.uiType = .both // possible native and html
        
        let yourCustomUi = UiCustomization()
        //Set various customizations here. See "iOS UI Customization" documentation for detail.
        config.uiCustomization = yourCustomUi
        
        config.renderType = [CardinalSessionRenderTypeOTP,
                             CardinalSessionRenderTypeHTML,
                             CardinalSessionRenderTypeOOB,
                             CardinalSessionRenderTypeSingleSelect,
                             CardinalSessionRenderTypeMultiSelect]
        
        // configure session
        session.configure(config)
    }
    
    public func setup(with jwt: String) {
        // JWT provided by ST in response to JSINIT request
        // TODO: session setup
    }
}
