//
//  TestExpiryDateInputView.swift
//  SecureTradingUITests
//

import XCTest
@testable import SecureTradingUI
@testable import SecureTradingCard

class TestExpiryDateInputView: XCTestCase {
    
    var sut: ExpiryDateInputView!
    override func setUp() {
        super.setUp()
        sut = ExpiryDateInputView()
    }
    
    func test_autocomplete5as05() {
        XCTAssertEqual("05", MonthTextField().autocomplete("5"))
    }
    func test_autocompleteDoesntChangeFor10() {
        XCTAssertEqual("10", MonthTextField().autocomplete("10"))
    }
    func test_autocompleteDoesntChangeFor0() {
        XCTAssertEqual("0", MonthTextField().autocomplete("0"))
    }
    func test_autocompleteDoesntChangeFor03() {
        XCTAssertEqual("03", MonthTextField().autocomplete("03"))
    }
    func test_autocompleteDoesntCrashForEmpty() {
        XCTAssertEqual("", MonthTextField().autocomplete(""))
    }
    func test_setSecureTextEntry() {
        sut.isSecuredTextEntry = true
        XCTAssertTrue(sut.monthTextField.isSecureTextEntry)
        XCTAssertTrue(sut.yearTextField.isSecureTextEntry)
    }
    func test_setKeyboardType() {
        sut.keyboardType = .emailAddress
        XCTAssertEqual(sut.monthTextField.keyboardType, UIKeyboardType.emailAddress)
        XCTAssertEqual(sut.yearTextField.keyboardType, UIKeyboardType.emailAddress)
    }
    func test_setKeyboardAppearance() {
        sut.keyboardAppearance = .dark
        XCTAssertEqual(sut.monthTextField.keyboardAppearance, UIKeyboardAppearance.dark)
        XCTAssertEqual(sut.yearTextField.keyboardAppearance, UIKeyboardAppearance.dark)
    }
    func test_isEmptyForNil() {
        sut.monthTextField.text = nil
        sut.yearTextField.text = nil
        XCTAssertTrue(sut.isEmpty)
    }
    func test_isEmptyForEmptyString() {
        sut.monthTextField.text = ""
        sut.yearTextField.text = ""
        XCTAssertTrue(sut.isEmpty)
    }
    func test_settingsTextChangesTextFields() {
        sut.text = "04/10"
        XCTAssertEqual("04", sut.monthTextField.text)
        XCTAssertEqual("10", sut.yearTextField.text)
    }
    func test_textReturnsValuesOfTextFields() {
        sut.monthTextField.text = "08"
        sut.yearTextField.text = "2043"
        XCTAssertEqual("08/2043", sut.text)
    }
    func test_settingsErrorMessageChangesLabel() {
        let given = "-Error-"
        sut.error = given
        XCTAssertEqual(sut.errorLabel.text, given)
    }
    func test_expiryDate() {
        sut.monthTextField.text = "08"
        sut.yearTextField.text = "2043"
        XCTAssertEqual(sut.expiryDate, "08/2043")
    }
    func test_isInputValid() {
        sut.monthTextField.text = "08"
        sut.yearTextField.text = "2043"
        XCTAssertTrue(sut.isInputValid)
    }
    func test_isInputInvalid() {
        sut.monthTextField.text = "16"
        sut.yearTextField.text = "2043"
        XCTAssertFalse(sut.isInputValid)
    }
    func test_setTitleColor() {
        sut.titleColor = UIColor.red
        XCTAssertEqual(sut.titleLabel.textColor, UIColor.red)
    }
}
