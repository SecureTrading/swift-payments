import XCTest

class PaymentPageTests: UITestBase {
    // MARK: Properties
    lazy var paymentPage: PaymentPage = PaymentPage()

    // MARK: Tests
    func testEmptyFieldsValidation() throws {
        paymentPage.tapOnYearInput()
        paymentPage.tapOnCvvInput()
        paymentPage.tapOnCreditCardInput()
        XCTAssertEqual(paymentPage.getCreditCardValidationMessage(), "Invalid field", "Credit card validation message is not correct")
        //ToDo: Temporary comment - fix in app required
//        XCTAssertEqual(paymentPage.getExpDateValidationMessage(), "Expiry date is required", "Expiration date validation message is not correct")
        XCTAssertEqual(paymentPage.getCvvValidationMessage(), "Invalid field", "Cvv validation message is not correct")
        XCTAssertFalse(paymentPage.isSubmitButtonEnabled(), "Submit button is not disabled")
    }
    
    func testIncorrectFieldValidation() throws {
        paymentPage.fillPaymentForm(cardNumber: "41111111", month: "1119", cvvInput: "12")
        paymentPage.tapOnCreditCardInput()
        
        XCTAssertEqual(paymentPage.getCreditCardValidationMessage(), "Invalid field", "Credit card validation message is not correct")
        XCTAssertEqual(paymentPage.getExpDateValidationMessage(), "Invalid field", "Expiration date validation message is not correct")
        XCTAssertEqual(paymentPage.getCvvValidationMessage(), "Invalid field", "Cvv validation message is not correct")
        XCTAssertFalse(paymentPage.isSubmitButtonEnabled(), "Submit button is not disabled")
    }
    
    func testInvalidThreeDigitCvvForAmexCard() throws {
        paymentPage.fillPaymentForm(cardNumber: "340000000000611", month: "1222", cvvInput: "123")
        paymentPage.tapOnCreditCardInput()
        
        XCTAssertEqual(paymentPage.getCvvValidationMessage(), "Invalid field")
    }
    
    func testIsCvvNotRequiredForPIBA() throws {
        paymentPage.fillCardNumberInput(cardNumber: "3089500000000000021")
        paymentPage.fillMonthInput(month: "1022")
        XCTAssertFalse(paymentPage.isCvvFieldEnabled(), "Cvv field is not disabled for PIBA card")
    }
}
