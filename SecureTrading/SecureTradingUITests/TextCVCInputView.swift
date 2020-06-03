//
//  TextCVCInputView.swift
//  SecureTradingUITests
//

import XCTest
@testable import SecureTradingUI

class TextCVCInputView: XCTestCase {
    
    func test_inputInvalidForEmpty() {
        let sut = CvcInputView()
        XCTAssertFalse(sut.isInputValid)
    }
    func test_inputIsValidForEmptyAndPiba() {
        let sut = CvcInputView()
        sut.cardType = .piba
        XCTAssertTrue(sut.isInputValid)
    }
    func test_placeholderHas4CharsForAmex() {
        let sut = CvcInputView()
        sut.cardType = .amex
        XCTAssertEqual(sut.placeholder.count, 4)
    }
    func test_placeholderHas3CharsForVisa() {
        let sut = CvcInputView()
        sut.cardType = .visa
        XCTAssertEqual(sut.placeholder.count, 3)
    }
    
}
