//
//  TestAPIManager.swift
//  SecureTradingCoreTests
//

import XCTest
@testable import SecureTradingCore

class TestAPIManager: XCTestCase {
    var api: DefaultAPIClient!

    func setAPIClientMock(withRequestTimeout: TimeInterval = 40, resourceTimeout: TimeInterval = 60) -> DefaultAPIClient {
        let configuration = DefaultAPIClientConfiguration(
            scheme: .https,
            host: GatewayType.eu.host)
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMock.self]
        config.timeoutIntervalForResource = resourceTimeout
        config.timeoutIntervalForRequest = withRequestTimeout
        let session = URLSession(configuration: config)
        return DefaultAPIClient(configuration: configuration, urlSession: session)
    }

    override func setUp() {
        super.setUp()
        let configuration = DefaultAPIClientConfiguration(
            scheme: .https,
            host: GatewayType.eu.host)
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        api = DefaultAPIClient(configuration: configuration, urlSession: session)
    }
    
    func test_failsOnError() {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        
        URLProtocolMock.requestHandler = { request in
            throw NSError(domain: "domain", code: 1, userInfo: nil)
        }
        api.perform(request: EmptyRequestMock()) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success:
                XCTFail("Should fail on error")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_failsOnNonHTTPResponse() {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        URLProtocolMock.requestHandler = { request in
            return (URLResponse(), Data())
        }
        api.perform(request: request) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.humanReadableDescription, APIClientError.responseValidationError(.missingResponse).humanReadableDescription)
            case .success:
                XCTFail("Should fail ")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_failsOnMissingData() {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        URLProtocolMock.requestHandler = { request in
            return (HTTPURLResponse(), nil)
        }
        api.perform(request: request) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success:
                XCTFail("Should fail ")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_failsOnResponseCodeBelow200() {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        URLProtocolMock.requestHandler = { request in
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 199, httpVersion: nil, headerFields: nil)!
            return (httpResponse, nil)
        }
        api.perform(request: request) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success:
                XCTFail("Should fail ")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_failsOnResponseCodeAbove299() {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        URLProtocolMock.requestHandler = { request in
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 300, httpVersion: nil, headerFields: nil)!
            return (httpResponse, Data())
        }
        api.perform(request: request) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success:
                XCTFail("Should fail ")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_badRequestForResponseCode400() {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        URLProtocolMock.requestHandler = { request in
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (httpResponse, Data())
        }
        api.perform(request: request) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertTrue(error.isBadRequestStatusCode)
            case .success:
                XCTFail("Should fail ")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_UnauthorizedForResponseCode401() {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        URLProtocolMock.requestHandler = { request in
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (httpResponse, Data())
        }
        api.perform(request: request) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertTrue(error.isUnauthorizedStatusCode)
            case .success:
                XCTFail("Should fail ")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_failsOnTimeout() {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        URLProtocolMock.requestHandler = { request in
            let error = NSError(domain: "domain", code: NSURLErrorTimedOut, userInfo: nil)
            throw error
        }
        api.perform(request: request) { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertTrue(error.isTimeoutError)
            case .success:
                XCTFail("Should fail ")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_successOnResponseCode200() throws {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        let dict = ["success": true]
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0))
        URLProtocolMock.requestHandler = { request in
            let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            return (httpResponse, jsonData)
        }
        api.perform(request: request) { (result) in
            switch result {
            case .failure:
                XCTFail("Should not fail")
            case .success(let response):
                XCTAssertNotNil(response)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_versionInfo() {
        let given = DefaultAPIManager(gatewayType: .eu, username: "st").versionInfo
        let expected = "MSDK::swift-5.2::0.0.1::iOS13.5.0"
        XCTAssertEqual(given, expected)
    }
    func test_requestRetry10timesForTimeout() throws {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        let expectedNumberOfRetries: Int = 10
        var retryNumber: Int = 0
        URLProtocolMock.requestHandler = { request in
            retryNumber += 1
            throw URLError(URLError.timedOut)
        }
        api.perform(request: request, maxRetries: expectedNumberOfRetries) { (result) in
            switch result {
            case .failure(let e):
                XCTAssertEqual(expectedNumberOfRetries, retryNumber)
                XCTAssertEqual(e.foundationError.code, APIClientError.inaccessible.foundationError.code)
            case .success:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_requestRetry10timesForCannotFindHost() throws {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        let expectedNumberOfRetries: Int = 10
        var retryNumber: Int = 0
        URLProtocolMock.requestHandler = { request in
            retryNumber += 1
            throw URLError(URLError.cannotFindHost)
        }
        api.perform(request: request, maxRetries: expectedNumberOfRetries) { (result) in
            switch result {
            case .failure(let e):
                XCTAssertEqual(expectedNumberOfRetries, retryNumber)
                XCTAssertEqual(e.foundationError.code, APIClientError.inaccessible.foundationError.code)
            case .success:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_requestRetry10timesForCannotConnectToHost() throws {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        let expectedNumberOfRetries: Int = 10
        var retryNumber: Int = 0
        URLProtocolMock.requestHandler = { request in
            retryNumber += 1
            throw URLError(URLError.cannotConnectToHost)
        }
        api.perform(request: request, maxRetries: expectedNumberOfRetries) { (result) in
            switch result {
            case .failure(let e):
                XCTAssertEqual(expectedNumberOfRetries, retryNumber)
                XCTAssertEqual(e.foundationError.code, APIClientError.inaccessible.foundationError.code)
            case .success:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_requestRetry10timesForNetworkConnectionLost() throws {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        let expectedNumberOfRetries: Int = 10
        var retryNumber: Int = 0
        URLProtocolMock.requestHandler = { request in
            retryNumber += 1
            throw URLError(URLError.networkConnectionLost)
        }
        api.perform(request: request, maxRetries: expectedNumberOfRetries) { (result) in
            switch result {
            case .failure(let e):
                XCTAssertEqual(expectedNumberOfRetries, retryNumber)
                XCTAssertEqual(e.foundationError.code, APIClientError.inaccessible.foundationError.code)
            case .success:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    func test_requestRetry10timesForDNSLookupFailed() throws {
        let expectation = XCTestExpectation(description: "Expectation: \(#function)")
        let request = EmptyRequestMock()
        let expectedNumberOfRetries: Int = 10
        var retryNumber: Int = 0
        URLProtocolMock.requestHandler = { request in
            retryNumber += 1
            throw URLError(URLError.dnsLookupFailed)
        }
        api.perform(request: request, maxRetries: expectedNumberOfRetries) { (result) in
            switch result {
            case .failure(let e):
                XCTAssertEqual(expectedNumberOfRetries, retryNumber)
                XCTAssertEqual(e.foundationError.code, APIClientError.inaccessible.foundationError.code)
            case .success:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
