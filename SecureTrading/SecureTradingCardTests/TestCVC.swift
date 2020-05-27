//
//  TestCVC.swift
//  SecureTradingCardTests
//

import XCTest
@testable import SecureTradingCard

class TestCVC: XCTestCase {
    
    // MARK: - Test security code length
    
    func test_amexCCVis4() {
        let card = CardType.amex
        XCTAssertEqual(card.securityCodeLength, 4)
    }
    func test_pibaCCVis0() {
        let card = CardType.piba
        XCTAssertEqual(card.securityCodeLength, 0)
    }
    func test_visaCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    func test_mastercardCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    func test_maestroCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    func test_discoverCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    func test_dinersCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    func test_jcbCCVis3() {
        let card = CardType.visa
        XCTAssertEqual(card.securityCodeLength, 3)
    }
    
    // MARK: - Test CVC
    func test_validThreeDigitCVC() {
        let code = "123"
        let isValid = CardValidator.isCVCValid(cvc: code, cardType: .visa)
        XCTAssertTrue(isValid)
    }
    func test_invalidThreeDigitCVCAmex() {
        let code = "123"
        let isValid = CardValidator.isCVCValid(cvc: code, cardType: .amex)
        XCTAssertFalse(isValid)
    }
    func test_fourDigitCVCAmex() {
        let code = "1234"
        let isValid = CardValidator.isCVCValid(cvc: code, cardType: .amex)
        XCTAssertTrue(isValid)
    }
    func test_invalidFourDigitCVCVisa() {
        let code = "1234"
        let isValid = CardValidator.isCVCValid(cvc: code, cardType: .visa)
        XCTAssertFalse(isValid)
    }
    func test_zeroDigitCVCPIBA() {
        let code = ""
        let isValid = CardValidator.isCVCValid(cvc: code, cardType: .piba)
        XCTAssertTrue(isValid)
    }
    func test_invalidMixedDigitCVCVisa() {
        let code = "1a2b3c"
        let isValid = CardValidator.isCVCValid(cvc: code, cardType: .visa)
        XCTAssertFalse(isValid)
    }
    func test_invalidNoneDigitCVCVisa() {
        let code = "abc"
        let isValid = CardValidator.isCVCValid(cvc: code, cardType: .visa)
        XCTAssertFalse(isValid)
    }
    func test_isCVCNotRequiredForPIBA() {
        let isRequired = CardValidator.isCVCRequired(for: .piba)
        XCTAssertFalse(isRequired)
    }
    func test_isCVCRequiredForAllExceptPiba() {
        let allCards = CardType.allCases.filter { $0 != .piba }
        for card in allCards {
            let isRequired = CardValidator.isCVCRequired(for: card)
            XCTAssertTrue(isRequired)
        }
    }
}
