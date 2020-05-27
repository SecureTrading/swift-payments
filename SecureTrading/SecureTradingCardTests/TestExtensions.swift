//
//  TestExtensions.swift
//  SecureTradingCardTests
//

import XCTest
@testable import SecureTradingCard

class TestExtensions: XCTestCase {
    
    // MARK: Test dependant extensions
    func test_removeClosedRangeFromClosedRange() {
        let givenRange: ClosedRange<Int> = 1...10
        let rangeToRemove: ClosedRange<Int> = 3...8
        let expectedRanges: [ClosedRange<Int>] = [1...2, 9...10]
        
        let sut = givenRange.remove(range: rangeToRemove)
        XCTAssertTrue(sut.count == 2)
        XCTAssertTrue(sut.contains(expectedRanges[0]))
        XCTAssertTrue(sut.contains(expectedRanges[1]))
    }
    func test_removeClosedRangeFromClosedRange_InvalidLowerbound() {
        let givenRange: ClosedRange<Int> = 1...10
        let rangeToRemove: ClosedRange<Int> = 0...8
        
        let sut = givenRange.remove(range: rangeToRemove)
        XCTAssertTrue(sut.isEmpty)
    }
    func test_removeClosedRangeFromClosedRange_InvalidUpperbound() {
        let givenRange: ClosedRange<Int> = 1...10
        let rangeToRemove: ClosedRange<Int> = 3...50
        let expectedRange: ClosedRange<Int> = 1...2
        
        let sut = givenRange.remove(range: rangeToRemove)
        XCTAssertTrue(sut.count == 1)
        XCTAssertTrue(sut.contains(expectedRange))
    }
    func test_removeClosedRangeFromClosedRange_InvalidBound() {
        let givenRange: ClosedRange<Int> = 1...10
        let rangeToRemove: ClosedRange<Int> = 0...50
        
        let sut = givenRange.remove(range: rangeToRemove)
        XCTAssertTrue(sut.isEmpty)
    }
}
