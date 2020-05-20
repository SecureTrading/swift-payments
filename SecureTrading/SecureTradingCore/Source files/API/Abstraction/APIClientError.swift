//
//  APIClientError.swift
//  SecureTradingCore
//

import Foundation

/// Contains errors that can be thrown by `APIClient`.
public enum APIClientError: HumanReadableError {
    /// The request could not be built.
    case requestBuildError(Error)
    /// There was a connection error.
    case connectionError(Error)
    /// Received response is not valid.
    case responseValidationError(APIResponseValidationError)
    /// Received response could not be parsed.
    case responseParseError(Error)
    /// A server-side error has occurred.
    case serverError(HumanReadableError)
    /// A custom error has occurred.
    case customError(HumanReadableError)
    /// Something really weird happend. Cannot detect the error.
    case unknownError
    /// jwtDecodingError
    case jwtDecodingInvalidBase64Url
    /// jwtDecodingError
    case jwtDecodingInvalidJSON
    /// jwtDecodingError
    case jwtDecodingInvalidPartCount

    // MARK: Properties

    /// Whether error is caused by "400 BAD REQUEST" status code.
    var isBadRequestStatusCode: Bool {
        return error(dueToStatusCode: 400)
    }

    /// Whether error is caused by "401 UNAUTHORIZED" status code.
    var isUnauthorizedStatusCode: Bool {
        return error(dueToStatusCode: 401)
    }

    /// Whether error is caused by timed out request.
    var isTimeoutError: Bool {
        if case .connectionError(let error) = self {
            return (error as NSError).code == NSURLErrorTimedOut
        }
        return false
    }

    /// - SeeAlso: HumanReadableStringConvertible.humanReadableDescription
    public var humanReadableDescription: String {
        switch self {
        case .requestBuildError(let error as NSError):
            return "Failed to build URL request: \(error.humanReadableDescription)"
        case .connectionError(let error as HumanReadableStringConvertible):
            return "Connection failure: \(error.humanReadableDescription)"
        case .responseValidationError(let error):
            return "Failed to validate URL response: \(error.localizedDescription)"
        case .responseParseError(let error as NSError):
            return "Failed to parse URL response: \(error.humanReadableDescription)"
        case .serverError(let error):
            return error.humanReadableDescription
        case .customError(let error):
            return error.humanReadableDescription
        case .unknownError:
            return "An unknown network error has occurred."
        case .jwtDecodingInvalidBase64Url:
            return "JWT decoding: invalid base64"
        case .jwtDecodingInvalidJSON:
            return "JWT decoding: invalid JSON"
        case .jwtDecodingInvalidPartCount:
            return "JWT decoding: number of parts does not equal 3"
        }
    }

    /// objc helpers
    private var domain: String {
        return "com.securetrading.SecureTradingCore"
    }

    /// objc helpers
    private var errorCode: Int {
        switch self {
        case .requestBuildError:
            return 100
        case .connectionError:
            return 101
        case .responseValidationError:
            return 102
        case .responseParseError:
            return 103
        case .serverError:
            return 104
        case .customError:
            return 105
        case .unknownError:
            return 106
        case .jwtDecodingInvalidBase64Url:
            return 107
        case .jwtDecodingInvalidJSON:
            return 108
        case .jwtDecodingInvalidPartCount:
            return 109
        }
    }

    /// expose error for objc
    var foundationError: NSError {
        return NSError(domain: domain, code: errorCode, userInfo: [
            NSLocalizedDescriptionKey: humanReadableDescription
        ])
    }

    // MARK: Functions

    /// Checks whether error is caused by given status code.
    ///
    /// - Parameter code: Code to check.
    /// - Returns: Flag inficating whether error is status cause by given code or not.
    private func error(dueToStatusCode statusCode: Int) -> Bool {
        if case .responseValidationError(.unacceptableStatusCode(statusCode, _)) = self {
            return true
        }
        return false
    }
}

/// Contains API response validation errors.
///
/// - unacceptableStatusCode: Thrown if response's status code is acceptable.
/// - missingResponse: Thrown if response is missing.
/// - missingData: Thrown if response is missing data.
public enum APIResponseValidationError: Error {
    case unacceptableStatusCode(actual: Int, expected: CountableClosedRange<Int>)
    case missingResponse
    case missingData

    // MARK: Properties

    /// - SeeAlso: Error.localizedDescription
    var localizedDescription: String {
        switch self {
        case .unacceptableStatusCode(let actual, _):
            return "Unacceptable status code: \(actual)."
        case .missingResponse, .missingData:
            return "Missing data."
        }
    }
}
