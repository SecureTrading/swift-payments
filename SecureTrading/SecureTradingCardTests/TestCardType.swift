//
//  TestCardType.swift
//  SecureTradingCardTests
//

import XCTest
@testable import SecureTradingCard

class TestCardType: XCTestCase {
    
    // MARK: - Test card types
    func test_isUnknownForSingleDigit() {
        // if card number starts with other digit that 4
        // then the card type cannot be determined
        // more digits are needed
        let expectedType = CardType.unknown
        let cardNumber = "5"
        XCTAssertEqual(expectedType, CardValidator.cardType(for: cardNumber))
    }
    func test_isUnknownForNonDigit() {
        // if card number starts with other digit that 4
        // then the card type cannot be determined
        // more digits are needed
        let expectedType = CardType.unknown
        let cardNumber = "5@dsa"
        XCTAssertEqual(expectedType, CardValidator.cardType(for: cardNumber))
    }
    func test_isUnknown() {
        let expectedType = CardType.unknown
        let cardNumbers = KnownCards.invalidCards
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isVisa() {
        let expectedType = CardType.visa
        let cardNumbers = KnownCards.visaCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isVisaIfStartsWith4() {
        let expectedType = CardType.visa
        let cardNumber = "4"
        XCTAssertEqual(expectedType, CardValidator.cardType(for: cardNumber))
        
    }
    func test_isMasterCard() {
        let expectedType = CardType.mastercard
        let cardNumbers = KnownCards.mastercardCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isMaestro() {
        let expectedType = CardType.maestro
        let cardNumbers = KnownCards.maestroCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isAmex() {
        let expectedType = CardType.amex
        let cardNumbers = KnownCards.amexCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isJCB() {
        let expectedType = CardType.jcb
        let cardNumbers = KnownCards.jcbCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isDiners() {
        let expectedType = CardType.diners
        let cardNumbers = KnownCards.dinerCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isDiscover() {
        let expectedType = CardType.discover
        let cardNumbers = KnownCards.discoverCards
        
        for card in cardNumbers {
            print("Discover: \(card)")
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    func test_isPIBA() {
        let expectedType = CardType.piba
        let cardNumbers = KnownCards.pibaCards
        
        for card in cardNumbers {
            XCTAssertEqual(expectedType, CardValidator.cardType(for: card))
        }
    }
    
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
    
    // MARK: - Luhn check
    func test_isVisaCardNumberLuhnValid() {
        let cardNumbers = KnownCards.visaCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isMastercardCardNumberLuhnValid() {
        let cardNumbers = KnownCards.mastercardCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isMaestroCardNumberLuhnValid() {
        let cardNumbers = KnownCards.maestroCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isAmexCardNumberLuhnValid() {
        let cardNumbers = KnownCards.amexCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isDiscoverCardNumberLuhnValid() {
        let cardNumbers = KnownCards.discoverCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isDinersCardNumberLuhnValid() {
        let cardNumbers = KnownCards.dinerCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isJCBCardNumberLuhnValid() {
        let cardNumbers = KnownCards.jcbCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isPIBACardNumberLuhnValid() {
        let cardNumbers = KnownCards.pibaCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertTrue(isValid)
        }
    }
    func test_isUnknownCardNumberLuhnInvalid() {
        let cardNumbers = KnownCards.invalidCards
        for card in cardNumbers {
            let isValid = CardValidator.isCardNumberLuhnCompliant(cardNumber: card)
            XCTAssertFalse(isValid)
        }
    }
    
    // MARK: Test Card Lengths
    func test_isVisaCardNumberLengthValid() {
        let cardNumbers = KnownCards.visaCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .visa)
            XCTAssertTrue(isValid)
        }
    }
    func test_isMastercardCardNumberLengthValid() {
        let cardNumbers = KnownCards.mastercardCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .mastercard)
            XCTAssertTrue(isValid)
        }
    }
    func test_isMaestroCardNumberLengthValid() {
        let cardNumbers = KnownCards.maestroCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .maestro)
            XCTAssertTrue(isValid)
        }
    }
    func test_isAmexCardNumberLengthValid() {
        let cardNumbers = KnownCards.amexCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .amex)
            XCTAssertTrue(isValid)
        }
    }
    func test_isDiscoverCardNumberLengthValid() {
        let cardNumbers = KnownCards.discoverCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .discover)
            XCTAssertTrue(isValid)
        }
    }
    func test_isDinersCardNumberLengthValid() {
        let cardNumbers = KnownCards.dinerCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .diners)
            XCTAssertTrue(isValid)
        }
    }
    func test_isJCBCardNumberLengthValid() {
        let cardNumbers = KnownCards.jcbCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .jcb)
            XCTAssertTrue(isValid)
        }
    }
    func test_isPIBACardNumberLengthValid() {
        let cardNumbers = KnownCards.pibaCards
        for card in cardNumbers {
            let isValid = CardValidator.cardNumberHasValidLength(cardNumber: card, card: .piba)
            XCTAssertTrue(isValid)
        }
    }
    func test_isUnknownCardNumberLengthInvalid() {
        let cardNumbers = ["1234", "1212121212211212123454545353"]
        let allCards = CardType.allCases
        for card in allCards {
            for cardNumber in cardNumbers {
                let isValid = CardValidator.cardNumberHasValidLength(cardNumber: cardNumber, card: card)
                XCTAssertFalse(isValid)
            }
        }
    }
    
    // MARK: - Test logo exists for card issuers
    func test_hasLogoForVisa() {
        let logo = CardType.visa.logo
        XCTAssertNotNil(logo)
    }
    func test_hasLogoForAmex() {
        let logo = CardType.amex.logo
        XCTAssertNotNil(logo)
    }
    func test_hasLogoForPIBA() {
        let logo = CardType.piba.logo
        XCTAssertNotNil(logo)
    }
    func test_hasLogoForMastercard() {
        let logo = CardType.mastercard.logo
        XCTAssertNotNil(logo)
    }
    func test_hasLogoForMaestro() {
        let logo = CardType.maestro.logo
        XCTAssertNotNil(logo)
    }
    func test_hasLogoForDiscover() {
        let logo = CardType.discover.logo
        XCTAssertNotNil(logo)
    }
    func test_hasLogoForDiners() {
        let logo = CardType.diners.logo
        XCTAssertNotNil(logo)
    }
    func test_hasLogoForJCB() {
        let logo = CardType.jcb.logo
        XCTAssertNotNil(logo)
    }
    
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
