//
//  DefaultAPIClient.swift
//  SecureTradingCore
//

import Foundation

final class DefaultAPIClient: APIClient {
    // MARK: Properties

    /// - SeeAlso: APIClient.configuration
    let configuration: APIClientConfiguration

    /// An instance of url session perfoming requests.
    private var urlSession: URLSession

    /// Default HTTP request headers.
    private var defaultRequestHeaders: [String: String] {
        return [:]
    }

    // MARK: Initialization

    /// Initializes an instance of the receiver.
    ///
    /// - Parameters:
    ///   - configuration: A base configuration of the client
    ///   - urlSession: URL session as a main interface for performing requests.
    init(configuration: APIClientConfiguration, urlSession: URLSession = .shared) {
        self.configuration = configuration
        self.urlSession = urlSession
    }

    /// set url session
    /// - Parameter urlSession: URL session as a main interface for performing requests.
    func setSession(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    // MARK: Functions

    /// - SeeAlso: APIClient.perform(request:completion:)
    func perform<Request>(request: Request, maxRetries: Int = 5, maxRetryInterval: TimeInterval = 40, completion: @escaping (Result<Request.Response, APIClientError>) -> Void) where Request: APIRequest {
        // Create convenience completion closures that will be reused later.
        let resolveSuccess: (Request.Response) -> Void = { response in
            let result: Result<Request.Response, APIClientError> = .success(response)
            DispatchQueue.main.async { completion(result) }
        }

        let resolveFailure: (APIClientError, Data?) -> Void = { error, _ in
            let result: Result<Request.Response, APIClientError> = .failure(error)
            DispatchQueue.main.async { completion(result) }
        }

        let parseClosure: (Data) -> Void = { data in
            do {
                // Parse a response.
                let decoder = Request.Response.decoder
                let parsedResponse = try decoder.decode(Request.Response.self, from: data)
                // validate response
                do {
                    // one response may be success and other may fail
                    // e.g request is for account check, 3d secure and auth
                    // account check is success but 3d secure fails
                    // a way to return that information may be needed
                    // so there is no need for another account check request
                    // the need will be resolved at the time when more complex
                    // requests will be implemented
                    try ResponseValidator.validate(request: request, response: parsedResponse)
                    resolveSuccess(parsedResponse)
                } catch let validationError as APIClientError {
                    resolveFailure(validationError, data)
                }
            } catch let err {
                do {
                    // Tries to parse response as JSON in the case of JWT parsing failure
                    // this happens when JWT has invalid or missing field, like iss
                    // check if has error and resolve failure
                    let responseError = try JSONDecoder().decode(ResponseError.self, from: data)
                    resolveFailure(.responseParseError(responseError.error), data)
                } catch {
                    resolveFailure(.responseParseError(err), data)
                }
            }
        }

        do {
            // Build a request.
            let builtRequest = try request.build(againstBaseURL: configuration.baseURL, defaultHeaders: defaultRequestHeaders)

            // Print to console if configured.
            if configuration.printRequests {
                print("------------------------------")
                print(request.debugDescription)
            }

            // perform the network request and retry automatically if needed
            urlSession.perform(builtRequest, maxRetries: maxRetries, maxRetryInterval: maxRetryInterval) { [weak self] dataResult in
                // If API client instance doesn't exist, return.
                guard let self = self else {
                    return
                }

                // check response and parse it appropriately
                switch dataResult {
                case .success(let data):
                    guard !request.isNoContentResponse else {
                        parseClosure("{ }".data(using: .utf8)!)
                        return
                    }
                    // Print to console if configured.
                    if self.configuration.printResponses {
                        print("------------------------------")
                        debugPrint(builtRequest.debugDescription)
                        do {
                            debugPrint(try JSONSerialization.jsonObject(with: data))
                        } catch {
                            print("Encoutered an error when serializing json object: \(error)")
                        }
                    }
                    parseClosure(data)
                case .failure(let networkError):
                    resolveFailure(networkError, nil)
                }
            }
        } catch {
            resolveFailure(.requestBuildError(error), nil)
        }
    }
}
