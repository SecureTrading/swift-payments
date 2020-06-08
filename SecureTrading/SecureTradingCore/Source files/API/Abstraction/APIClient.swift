//
//  APIClient.swift
//  SecureTradingCore
//

/// Performs API requests.
protocol APIClient: AnyObject {
    /// The configuration of the client.
    var configuration: APIClientConfiguration { get }

    /// Performs the API request and returns a future of its response.
    ///
    /// - Parameters:
    ///   - request: The request to be performed.
    ///   - completion: The completion closure containing result of an operation.
    func perform<Request>(request: Request, maxRetries: Int, maxRetryInterval: TimeInterval, completion: @escaping (Result<Request.Response, APIClientError>) -> Void) where Request: APIRequest
}
