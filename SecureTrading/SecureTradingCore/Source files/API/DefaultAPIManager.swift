//
//  DefaultAPIManager.swift
//  SecureTradingCore
//

import Foundation

@objc public final class DefaultAPIManager: NSObject, APIManager, APIManagerObjc {
    // MARK: Properties

    /// - SeeAlso: APIClient
    private let apiClient: APIClient
    /// merchant's username
    private let username: String
    /// JSON format version
    private let version = "1.00"
    /// sdk name
    private let sdkName = "MSDK"
    /// swift language version
    private var swiftVersion: String {
        #if swift(>=5.2)
        return "swift-5.2"
        #elseif swift(>=5.1)
        return "swift-5.1"
        #elseif swift(>=5.0)
        return "swift-5.0"
        #elseif swift(>=4.2)
        return "swift-4.2"
        #elseif swift(>=4.1)
        return "swift-4.1"
        #endif
    }

    // timeouts
    private let maxNumberOfRetries: Int = 20
    private let maxIntervalForRetries: TimeInterval = 40
    private let maxRequestTime: TimeInterval = 5

    /// sdk release version
    private var sdkVersion: String {
        return Bundle(for: DefaultAPIManager.self).releaseVersionNumber ?? ""
    }

    /// ios version
    private var iosVersion: String {
        let os = ProcessInfo().operatingSystemVersion
        return "iOS\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
    }

    /// version info for general request parameter
    var versionInfo: String {
        return "\(self.sdkName)::\(self.swiftVersion)::\(self.sdkVersion)::\(self.iosVersion)"
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - gatewayType: gateway type (us or european)
    ///   - username: merchant's username
    @objc public init(gatewayType: GatewayType, username: String) {
        self.username = username
        let configuration = DefaultAPIClientConfiguration(scheme: .https, host: gatewayType.host)
        let session = URLSession.shared
        session.configuration.timeoutIntervalForResource = maxRequestTime
        self.apiClient = DefaultAPIClient(configuration: configuration, urlSession: session)
    }

    // MARK: Functions

    /// Performs the payment transaction request
    /// - Parameters:
    ///   - jwt: encoded JWT token
    ///   - request: object in which transaction parameters should be specified (e.g. what type - auth, 3dsecure etc)
    ///   - success: success closure with response object (decoded transaction response, in which settle status and transaction error code can be checked), and and a JWT key that allows you to check the signature
    ///   - failure: failure closure with general APIClient error like: connection error, server error, decoding problem
    public func makeGeneralRequest(jwt: String, request: RequestObject, success: @escaping ((_ jwtResponse: JWTResponseObject, _ jwt: String) -> Void), failure: @escaping ((_ error: APIClientError) -> Void)) {
        let generalRequest = GeneralRequest(alias: self.username, jwt: jwt, version: self.version, versionInfo: self.versionInfo, requests: [request])
        self.apiClient.perform(request: generalRequest,
                               maxRetries: maxNumberOfRetries,
                               maxRetryInterval: maxIntervalForRetries) { result in
            switch result {
            case let .success(response):
                success(response.jwtResponses.first!, jwt)
            case let .failure(error):
                failure(error)
            }
        }
    }

    /// Performs the payment transaction request
    /// - Parameters:
    ///   - jwt: encoded JWT token
    ///   - request: object in which transaction parameters should be specified (e.g. what type - auth, 3dsecure etc)
    ///   - success: success closure with response object (decoded transaction response, in which settle status and transaction error code can be checked), and and a JWT key that allows you to check the signature
    ///   - failure: failure closure with general APIClient error like: connection error, server error, decoding problem
    @objc public func makeGeneralRequest(jwt: String, request: RequestObject, success: @escaping ((_ jwtResponse: JWTResponseObject, _ jwt: String) -> Void), failure: @escaping ((_ error: NSError) -> Void)) {
        self.makeGeneralRequest(jwt: jwt, request: request, success: success) { (error: APIClientError) in
            failure(error.foundationError)
        }
    }

    /// Performs the payment transaction requests
    /// - Parameters:
    ///   - jwt: encoded JWT token
    ///   - requests: request objects (in each object transaction parameters should be specified - e.g. what type - auth, 3dsecure etc)
    ///   - success: success closure with response objects (decoded transaction responses, in which settle status and transaction error code can be checked), and and a JWT key that allows you to check the signature
    ///   - failure: failure closure with general APIClient error like: connection error, server error, decoding problem
    public func makeGeneralRequests(jwt: String, requests: [RequestObject], success: @escaping ((_ jwtResponses: [JWTResponseObject], _ jwt: String) -> Void), failure: @escaping ((_ error: APIClientError) -> Void)) {
        let generalRequest = GeneralRequest(alias: self.username, jwt: jwt, version: self.version, versionInfo: self.versionInfo, requests: requests)
        self.apiClient.perform(request: generalRequest,
                               maxRetries: maxNumberOfRetries,
                               maxRetryInterval: maxIntervalForRetries) { result in
            switch result {
            case let .success(response):
                success(response.jwtResponses, jwt)
            case let .failure(error):
                failure(error)
            }
        }
    }

    /// Performs the payment transaction requests
    /// - Parameters:
    ///   - jwt: encoded JWT token
    ///   - requests: request objects (in each object transaction parameters should be specified - e.g. what type - auth, 3dsecure etc)
    ///   - success: success closure with response objects (decoded transaction responses, in which settle status and transaction error code can be checked), and and a JWT key that allows you to check the signature
    ///   - failure: failure closure with general APIClient error like: connection error, server error, decoding problem
    @objc public func makeGeneralRequests(jwt: String, requests: [RequestObject], success: @escaping ((_ jwtResponses: [JWTResponseObject], _ jwt: String) -> Void), failure: @escaping ((_ error: NSError) -> Void)) {
        self.makeGeneralRequests(jwt: jwt, requests: requests, success: success) { (error: APIClientError) in
            failure(error.foundationError)
        }
    }
}
