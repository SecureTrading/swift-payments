//
//  STClaims.swift
//  Example
//

import SwiftJWT

struct STClaims: Claims {
    let iss: String
    let iat: Date // no later than 60mins from now
    let payload: Payload
}

struct Payload: Codable {
    let accounttypedescription: String
    let sitereference: String
    let currencyiso3a: String?
    let baseamount: Int?
    let pan: String?
    let expirydate: String?
    let securitycode: String?
    let parenttransactionreference: String?
    let subscriptiontype: String?
    let subscriptionfinalnumber: String?
    let subscriptionunit: String?
    let subscriptionfrequency: String?
    let subscriptionnumber: String?
    let credentialsonfile: String?

    init(accounttypedescription: String,
         sitereference: String,
         currencyiso3a: String? = nil,
         baseamount: Int? = nil,
         pan: String? = nil,
         expirydate: String? = nil,
         securitycode: String? = nil,
         parenttransactionreference: String? = nil,
         subscriptiontype: String? = nil,
         subscriptionfinalnumber: String? = nil,
         subscriptionunit: String? = nil,
         subscriptionfrequency: String? = nil,
         subscriptionnumber: String? = nil,
         credentialsonfile: String? = nil) {
        self.accounttypedescription = accounttypedescription
        self.sitereference = sitereference
        self.currencyiso3a = currencyiso3a
        self.baseamount = baseamount
        self.pan = pan
        self.expirydate = expirydate
        self.securitycode = securitycode
        self.parenttransactionreference = parenttransactionreference
        self.subscriptiontype = subscriptiontype
        self.subscriptionfinalnumber = subscriptionfinalnumber
        self.subscriptionunit = subscriptionunit
        self.subscriptionfrequency = subscriptionfrequency
        self.subscriptionnumber = subscriptionnumber
        self.credentialsonfile = credentialsonfile
    }
}

extension String {
    private func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 += padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }

    var parentReference: String? {
        let body = self.components(separatedBy: ".")[1]
        guard let decoded = base64UrlDecode(body) else { return nil }
        guard let payload = try? JSONDecoder().decode(STClaims.self, from: decoded).payload else { return nil }
        return payload.parenttransactionreference
    }
}
