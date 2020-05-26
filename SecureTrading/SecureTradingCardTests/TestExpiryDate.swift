//
//  TestExpiryDate.swift
//  SecureTradingCardTests
//

import XCTest
@testable import SecureTradingCard

class TestExpiryDate: XCTestCase {
    
    // MARK: - Test expiration date parsing
    func test_validExpirationDateSingleDigitMonth_StandardSeparator() {
        let date = "1/2022"
        let isValid = CardValidator.isExpirationDateValid(date: date)
        XCTAssertTrue(isValid)
    }
    func test_validExpirationDateDoubleDigitMonth_StandardSeparator() {
        let date = "11/2022"
        let isValid = CardValidator.isExpirationDateValid(date: date)
        XCTAssertTrue(isValid)
    }
    func test_validExpirationDateDoubleDigitLeadingZeroMonth_StandardSeparator() {
        let date = "05/2022"
        let isValid = CardValidator.isExpirationDateValid(date: date)
        XCTAssertTrue(isValid)
    }
    func test_validExpirationDateDoubleDigitLeadingZeroMonth_CustomSeparator() {
        let date = "05-2022"
        let isValid = CardValidator.isExpirationDateValid(date: date, separator: "-")
        XCTAssertTrue(isValid)
    }
    func test_dateInPast_StandardSeparator() {
        let date = "05/2019"
        let isValid = CardValidator.isExpirationDateValid(date: date)
        XCTAssertFalse(isValid)
    }
    func test_currentDate_StandardSeparator() {
        let currentComponents = Calendar.current.dateComponents([.year, .month], from: Date())
        let date = "\(currentComponents.month!)/\(currentComponents.year!)"
        let isValid = CardValidator.isExpirationDateValid(date: date)
        XCTAssertTrue(isValid)
    }
}
