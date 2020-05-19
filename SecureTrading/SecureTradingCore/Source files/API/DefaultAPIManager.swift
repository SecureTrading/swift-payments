//
//  DefaultAPIManager.swift
//  SecureTradingCore
//

import Foundation

@objc public final class DefaultAPIManager: NSObject, APIManager {

    // MARK: Properties

    /// - SeeAlso: APIClient
    private let apiClient: APIClient
    /// merchant's username
    private let username: String
    /// JSON format version
    private let version = "1.00"

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    /// - Parameters:
    ///   - gatewayType: gateway type (us or european)
    ///   - username: merchant's username
    @objc public init(gatewayType: GatewayType, username: String) {
        self.username = username
        let configuration = DefaultAPIClientConfiguration(scheme: .https, host: gatewayType.host)
        self.apiClient = DefaultAPIClient(configuration: configuration)
    }

    // MARK: Functions

    // todo
    @objc public func makeGeneralRequest(jwt: String, request: RequestObject, success: @escaping ((_ jwtResponse: JWTResponseObject, _ jwt: String) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        let generalRequest = GeneralRequest(alias: self.username, jwt: jwt, version: self.version, requests: [request])
        self.apiClient.perform(request: generalRequest) { result in
            switch result {
            case let .success(response):
                success(response.jwtResponses.first!, jwt)
            case let .failure(error):
                failure(error)
            }
        }
    }

    // todo
    @objc public func makeGeneralRequests(jwt: String, requests: [RequestObject], success: @escaping ((_ jwtResponses: [JWTResponseObject], _ jwt: String) -> Void), failure: @escaping ((_ error: Error) -> Void)) {
        let generalRequest = GeneralRequest(alias: self.username, jwt: jwt, version: self.version, requests: requests)
        self.apiClient.perform(request: generalRequest) { result in
            switch result {
            case let .success(response):
                success(response.jwtResponses, jwt)
            case let .failure(error):
                failure(error)
            }
        }
    }

    // todo (future task) move it to the unit test
    @objc public func checkJWTDecoding() {
        // swiftlint:disable line_length
        let jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1ODkyODU0MjEsInBheWxvYWQiOnsicmVxdWVzdHJlZmVyZW5jZSI6IlcyLTBlMnYwOHYwIiwidmVyc2lvbiI6IjEuMDAiLCJqd3QiOiJleUpoYkdjaU9pSklVekkxTmlJc0luUjVjQ0k2SWtwWFZDSjkuZXlKcGMzTWlPaUpxZDNRdGNHZHpiVzlpYVd4bGMyUnJJaXdpYVdGMElqb3hOVGc1TWpnMU5ESXhMQ0p3WVhsc2IyRmtJanA3SW1OMWNuSmxibU41YVhOdk0yRWlPaUpIUWxBaUxDSmlZWE5sWVcxdmRXNTBJam94TURVd0xDSnphWFJsY21WbVpYSmxibU5sSWpvaWRHVnpkRjl3WjNOdGIySnBiR1Z6WkdzM09UUTFPQ0lzSW1WNGNHbHllV1JoZEdVaU9pSXhNaTh5TURJeUlpd2ljR0Z5Wlc1MGRISmhibk5oWTNScGIyNXlaV1psY21WdVkyVWlPaUl5TFRrdE5EWXhOelUzTWlJc0luTmxZM1Z5YVhSNVkyOWtaU0k2SWpFeU15SXNJbUZqWTI5MWJuUjBlWEJsWkdWelkzSnBjSFJwYjI0aU9pSkZRMDlOSWl3aWNHRnVJam9pTkRFeE1URXhNVEV4TVRFeE1URXhNU0o5ZlEuUkpRX0xsSVNnVFlLQmwyM1F6b2JhTVcyT1lDUm1jeElzUkY1N2RjSm92SSIsInJlc3BvbnNlIjpbeyJ0cmFuc2FjdGlvbnN0YXJ0ZWR0aW1lc3RhbXAiOiIyMDIwLTA1LTEyIDEyOjEwOjIxIiwibGl2ZXN0YXR1cyI6IjAiLCJpc3N1ZXIiOiJTZWN1cmVUcmFkaW5nIFRlc3QgSXNzdWVyMSIsInNwbGl0ZmluYWxudW1iZXIiOiIxIiwiZGNjZW5hYmxlZCI6IjAiLCJzZXR0bGVkdWVkYXRlIjoiMjAyMC0wNS0xMiIsImVycm9yY29kZSI6IjAiLCJ0aWQiOiIyNzg4Mjc4OCIsIm1lcmNoYW50bnVtYmVyIjoiMDAwMDAwMDAiLCJzZWN1cml0eXJlc3BvbnNlcG9zdGNvZGUiOiIwIiwidHJhbnNhY3Rpb25yZWZlcmVuY2UiOiIyLTktNDYxNzU3MiIsIm1lcmNoYW50bmFtZSI6InBncyBtb2JpbGUgc2RrIiwicGF5bWVudHR5cGVkZXNjcmlwdGlvbiI6IlZJU0EiLCJiYXNlYW1vdW50IjoiMTA1MCIsImFjY291bnR0eXBlZGVzY3JpcHRpb24iOiJFQ09NIiwiYWNxdWlyZXJyZXNwb25zZWNvZGUiOiIwMCIsInJlcXVlc3R0eXBlZGVzY3JpcHRpb24iOiJBVVRIIiwic2VjdXJpdHlyZXNwb25zZXNlY3VyaXR5Y29kZSI6IjIiLCJjdXJyZW5jeWlzbzNhIjoiR0JQIiwiYXV0aGNvZGUiOiJURVNUNDUiLCJlcnJvcm1lc3NhZ2UiOiJPayIsImlzc3VlcmNvdW50cnlpc28yYSI6IlVTIiwibWVyY2hhbnRjb3VudHJ5aXNvMmEiOiJHQiIsIm1hc2tlZHBhbiI6IjQxMTExMSMjIyMjIzExMTEiLCJzZWN1cml0eXJlc3BvbnNlYWRkcmVzcyI6IjAiLCJvcGVyYXRvcm5hbWUiOiJqd3QtcGdzbW9iaWxlc2RrIiwic2V0dGxlc3RhdHVzIjoiMCJ9XSwic2VjcmFuZCI6ImxybiJ9LCJhdWQiOiJqd3QtcGdzbW9iaWxlc2RrIn0.Czy1XkFgoWpz19Flee3AtjjSNPcsBtk2daS4wa3JxQA"
        // swiftlint:enable line_length

        let jwtDecoded = try? DecodedJWT(jwt: jwt)
        let jwtResponses = jwtDecoded?.jwtBodyResponse.responses
    }
}
