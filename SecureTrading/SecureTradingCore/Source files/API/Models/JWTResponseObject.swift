//
//  JWTResponse.swift
//  SecureTradingCore
//

@objc public class JWTResponseObject: NSObject, Codable {
    // MARK: Properties

    let errorCode: String
    let errorMessage: String

}

private extension JWTResponseObject {
    enum CodingKeys: String, CodingKey {
        case errorCode = "errorcode"
        case errorMessage = "errormessage"
    }
}
