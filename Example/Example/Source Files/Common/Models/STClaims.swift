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
