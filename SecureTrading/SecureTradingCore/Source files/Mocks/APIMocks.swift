//
//  APIMocks.swift
//  SecureTradingCore
//

import Foundation

final class EmptyResponseMock: APIResponse { }

final class EmptyRequestMock: APIRequestModel {
    typealias Response = EmptyResponseMock
    var method: APIRequestMethod { return .post }
    var path: String { return "" }
    var isNoContentResponse: Bool
    
    init(isNoContent: Bool = false) {
        self.isNoContentResponse = isNoContent
    }
}

final class MockAPIClient: APIClient {
    struct MockAPIClientConfiguration: APIClientConfiguration {
        var scheme = Scheme.https
        var host = ""
    }
    var configuration: APIClientConfiguration {
        return MockAPIClientConfiguration()
    }
    
    func perform<Request>(request: Request, maxRetries: Int = 5, completion: @escaping (Result<Request.Response, APIClientError>) -> Void) where Request: APIRequest {
        // Empty by design
    }
    
    func retry() {
        // Empty by design
    }
}
