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
    /// request inaccessible after retries
    case inaccessible
    /// `URLSession` errors are passed-through, handle as appropriate.
    /// needed to determine whether a retry of request should happen
    case urlError(URLError)

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
        case .inaccessible:
            return "Failed to receive a response for request after given retries"
        case .urlError(let urlError):
            return "URL Error: \(urlError.localizedDescription)"
        }
    }

    /// Used to determine whether a network request should be retried
    var shouldRetry: Bool {
        switch self {
        case .urlError(let urlError):
            //  retry for network issues
            switch urlError.code {
            case URLError.timedOut,
                 URLError.cannotFindHost,
                 URLError.cannotConnectToHost,
                 URLError.networkConnectionLost,
                 URLError.dnsLookupFailed:
                return true
            default: break
            }
        default: break
        }
        return false
    }

    /// objc helpers
    private var errorCode: Int {
        switch self {
        case .requestBuildError:
            return 10_000
        case .connectionError:
            return 11_000
        case .responseValidationError:
            return 12_000
        case .responseParseError:
            return 13_000
        case .serverError:
            return 14_000
        case .customError:
            return 15_000
        case .unknownError:
            return 16_000
        case .jwtDecodingInvalidBase64Url:
            return 17_000
        case .jwtDecodingInvalidJSON:
            return 18_000
        case .jwtDecodingInvalidPartCount:
            return 19_000
        case .inaccessible:
            return 20_000
        case .urlError(let urlError):
            return urlError.code.rawValue
        }
    }

    /// expose error for objc
    var foundationError: NSError {
        switch self {
            // compose more detailed and descriptive error
        case .responseValidationError(let responseError):
            let localizedError = humanReadableDescription + " " + responseError.localizedDescription
            return NSError(domain: NSError.domain, code: responseError.errorCode, userInfo: [
                NSLocalizedDescriptionKey: localizedError
            ])
        default:
            return NSError(domain: NSError.domain, code: errorCode, userInfo: [
                NSLocalizedDescriptionKey: humanReadableDescription
            ])
        }
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
/// - unacceptableStatusCode: Thrown if response's status code is not acceptable.
/// - missingResponse: Thrown if response is missing.
/// - missingData: Thrown if response is missing data.
/// - mismatchedDescriptionTypes: Thrown when response type descriptions does not match request's ones
/// - invalidField: Thrown when one of fields in JWT does not pass validation on gateway side
public enum APIResponseValidationError: Error {
    case unacceptableStatusCode(actual: Int, expected: CountableClosedRange<Int>)
    case missingResponse
    case missingData
    case mismatchedDescriptionTypes
    case invalidField(code: ResponseErrorDetail)
    // MARK: Properties

    /// - SeeAlso: Error.localizedDescription
    public var localizedDescription: String {
        switch self {
        case .unacceptableStatusCode(let actual, _):
            return "Unacceptable status code: \(actual)."
        case .missingResponse, .missingData:
            return "Missing data."
        case .mismatchedDescriptionTypes:
            return "Unexpected description types in response."
        case .invalidField(let code):
            return code.message
        }
    }

    var errorCode: Int {
        // The error code adds to the error code value of responseValidationError in APIClientError
        // which it extends to more detailed level
        switch self {
        case .mismatchedDescriptionTypes: return 12_100
        case .missingData: return 12_200
        case .missingResponse: return 12_300
        case .unacceptableStatusCode: return 12_400
        case .invalidField(let responseErrorDetail): return responseErrorDetail.rawValue
        }
    }
}
