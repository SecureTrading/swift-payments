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
    private let urlSession: URLSession

    /// A range of acceptable status codes.
    private let defaultAcceptableStatusCodes = 200...299

    /// Retry operation.
    private var retryOperation: (() -> Void)?

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

    // MARK: Functions

    func retry() {
        let oldRetryOperation = retryOperation
        retryOperation = nil
        oldRetryOperation?()
    }

    /// - SeeAlso: APIClient.perform(request:completion:)
    func perform<Request>(request: Request, completion: @escaping (Result<Request.Response, APIClientError>) -> Void) where Request: APIRequest {

        // Create convenience completion closures that will be reused later.
        let resolveSuccess: (Request.Response) -> Void = { response in
            let result: Result<Request.Response, APIClientError> = .success(response)
            DispatchQueue.main.async { completion(result) }
        }

        let resolveFailure: (APIClientError, Data?) -> Void = { error, data in
            let result: Result<Request.Response, APIClientError> = .failure(error)
            DispatchQueue.main.async { completion(result) }
        }

        let parseClosure: (Data) -> Void = { data in
            do {
                // Parse a response.
                let decoder = Request.Response.decoder
                let parsedResponse = try decoder.decode(Request.Response.self, from: data)

                // Resolve success with a parsed response.
                resolveSuccess(parsedResponse)
            } catch {
                resolveFailure(.responseParseError(error), data)
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

            // Send a built request.
            urlSession.dataTask(with: builtRequest) { [weak self] data, response, error in

                // If API client instance doesn't exist, return.
                guard let self = self else {
                    return
                }

                // If there was an error, resolve failure immediately.
                if let error = error {
                    resolveFailure(.connectionError(error), data)
                    return
                }

                guard !request.isNoContentResponse else {
                    parseClosure("{ }".data(using: .utf8)!)
                    return
                }

                // If the response is invalid, resolve failure immediately.
                guard let response = response as? HTTPURLResponse else {
                    resolveFailure(.responseValidationError(.missingResponse), data)
                    return
                }

                // If data is missing, resolve failure immediately. Missing
                // data is not the same as zero-width data – the former is
                // considered erroreus.
                guard let data = data else {
                    resolveFailure(.responseValidationError(.missingData), nil)
                    return
                }

                // Validate against acceptable status codes.
                guard self.defaultAcceptableStatusCodes.contains(response.statusCode) else {
                    let validationError = APIClientError.responseValidationError(.unacceptableStatusCode(actual: response.statusCode, expected: self.defaultAcceptableStatusCodes))
                    resolveFailure(validationError, data)
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
            }.resume()
        } catch {
            resolveFailure(.requestBuildError(error), nil)
        }
    }
}
