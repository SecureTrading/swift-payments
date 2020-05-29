//
//  Mocks.swift
//  SecureTradingCoreTests
//

import Foundation
@testable import SecureTradingCore

class URLProtocolMock: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (URLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = URLProtocolMock.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    override func stopLoading() { }
}
class EmptyResponseMock: APIResponse { }
class EmptyRequestMock: APIRequestModel {
    typealias Response = EmptyResponseMock
    var method: APIRequestMethod { return .post }
    var path: String { return "" }
    var isNoContentResponse: Bool
    
    init(isNoContent: Bool = false) {
        self.isNoContentResponse = isNoContent
    }
}


/// Provides stubbed data task.
/// Class should be used only for testing purposes
final class StubbedURLSessionDataTask: URLSessionDataTask {
    // MARK: Properties
    typealias DataTaskCompletion = (Data?, URLResponse?, Error?) -> Void
    
    /// - SeeAlso: URLRequest
    let request: URLRequest
    /// Request completion handler
    let completion: DataTaskCompletion
    
    // MARK: Initialization
    /// Initializes an instance of the receiver.
    ///
    
    /// - Parameters:
    ///   - request: Network request
    ///   - completion: Completion handler
    init(request: URLRequest, completion: @escaping DataTaskCompletion) {
        self.request = request
        self.completion = completion
    }
    
    // MARK: Functions
    
    /// - SeeAlso: URLSessionDataTask.resume
    override func resume() {
        var nameComponents = request.url!.path.components(separatedBy: "/").filter { !$0.isEmpty }
        nameComponents.append(request.httpMethod!.lowercased())
        let jsonFile = nameComponents.joined(separator: ".")
        
        let bundle = Bundle(for: type(of: self))
        let jsonPath = bundle.path(forResource: jsonFile, ofType: "json")!
        // swiftlint:disable force_try
        let data = try! Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
        // swiftlint:enable force_try
        let response: HTTPURLResponse?
        
        if let headers = request.allHTTPHeaderFields, headers["Authorization"] == "Bearer", jsonFile != "authn.session.put" {
            response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)
        } else {
            response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        }
        completion(data, response, nil)
    }
}

final class TestBundleJSONDecoder {
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func decode<T>(model: T.Type, fromFile fileName: String, customize: ((inout [String: Any]) -> Void)? = nil) throws -> T where T: Decodable {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: fileName, ofType: "json")!
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        guard let customize = customize,
            var jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            else {
                return try decoder.decode(model, from: data)
        }
        
        customize(&jsonObject)
        let customizedData = try JSONSerialization.data(withJSONObject: jsonObject)
        return try decoder.decode(model, from: customizedData)
    }
}
private final class MockAPIClient: APIClient {
    struct MockAPIClientConfiguration: APIClientConfiguration {
        var scheme = Scheme.https
        var host = ""
    }
    var configuration: APIClientConfiguration {
        return MockAPIClientConfiguration()
    }
    
    func perform<Request>(request: Request, completion: @escaping (Result<Request.Response, APIClientError>) -> Void) where Request: APIRequest {
        // Empty by design
    }
    
    func retry() {
        // Empty by design
    }
}
