import XCTest

class PaymentPageTests: UITestBase {
    // MARK: Properties
    lazy var paymentPage: PaymentPage = PaymentPage()

    // MARK: Tests
    func testEmptyFieldsValidation() throws {
        paymentPage.tapOnYearInput()
        paymentPage.tapOnCvvInput()
        paymentPage.tapOnCreditCardInput()
        XCTAssertEqual(paymentPage.getCreditCardValidationMessage(), "Card number is required", "Credit card validation message is not correct")
        //ToDo: Temporary comment - fix in app required
//        XCTAssertEqual(paymentPage.getExpDateValidationMessage(), "Expiry date is required", "Expiration date validation message is not correct")
        XCTAssertEqual(paymentPage.getCvvValidationMessage(), "Security code is required", "Cvv validation message is not correct")
        XCTAssertFalse(paymentPage.isSubmitButtonEnabled(), "Submit button is not disabled")
    }
    
    func testIncorrectFieldValidation() throws {
        paymentPage.fillPaymentForm(cardNumber: "41111111", month: "1119", cvvInput: "12")
        paymentPage.tapOnCreditCardInput()
        
        XCTAssertEqual(paymentPage.getCreditCardValidationMessage(), "Invalid card number", "Credit card validation message is not correct")
        XCTAssertEqual(paymentPage.getExpDateValidationMessage(), "Invalid expiry date", "Expiration date validation message is not correct")
        XCTAssertEqual(paymentPage.getCvvValidationMessage(), "Invalid security code", "Cvv validation message is not correct")
        XCTAssertFalse(paymentPage.isSubmitButtonEnabled(), "Submit button is not disabled")
    }
    
    func testInvalidThreeDigitCvvForAmexCard() throws {
        paymentPage.fillPaymentForm(cardNumber: "340000000000611", month: "1222", cvvInput: "123")
        paymentPage.tapOnCreditCardInput()
        
        XCTAssertEqual(paymentPage.getCvvValidationMessage(), "Invalid security code")
    }
    
    func testIsCvvNotRequiredForPIBA() throws {
        paymentPage.fillCardNumberInput(cardNumber: "3089500000000000021")
        paymentPage.fillMonthInput(month: "1022")
        XCTAssertFalse(paymentPage.isCvvFieldEnabled(), "Cvv field is not disabled for PIBA card")
    }
    
//    ToDo: Investigate how get card info
//    func testCreditCardRecognitionForVisa() throws {
//        paymentPage.fillCardNumberInput(cardNumber: "4916477287051663")
//    }
//
//    func testCreditCardRecognitionForMasterCard() throws {
//        paymentPage.fillCardNumberInput(cardNumber: "5319765425806323")
//    }
    
//    ToDo - placeholders for future tests
//    func testPaymentFlow_SuccessStepUp() throws {
//        paymentPage.fillPaymentForm(cardNumber: "4000000000001091", month: "1224", cvvInput: "123")
//        paymentPage.tapSubmitButton()
//
//        XCTAssertEqual(paymentPage.getPaymentStatusMessage(), "Payment has been successfully processed.")
//    }
//
//    func testPaymentFlow_FailedStepUp() throws {
//        paymentPage.fillPaymentForm(cardNumber: "5200000000001104", month: "1224", cvvInput: "123")
//        paymentPage.tapSubmitButton()
//
//        XCTAssertEqual(paymentPage.getPaymentStatusMessage(), "Decline")
//    }
//
//    func testPaymentFlow_SuccessFrictionless() throws {
//        paymentPage.fillPaymentForm(cardNumber: "4000000000001026", month: "1224", cvvInput: "123")
//        paymentPage.tapSubmitButton()
//
//        XCTAssertEqual(paymentPage.getPaymentStatusMessage(), "Payment has been successfully processed.")
//    }
//
//    func testPaymentFlow_FailedFrictionless() throws {
//        paymentPage.fillPaymentForm(cardNumber: "4000000000001018", month: "1224", cvvInput: "123")
//        paymentPage.tapSubmitButton()
//
//        XCTAssertEqual(paymentPage.getPaymentStatusMessage(), "Decline")
//    }
//
//    func testPaymentFlow_DeclinedPayment() throws {
//        paymentPage.fillPaymentForm(cardNumber: "4242424242424242", month: "1224", cvvInput: "123")
//        paymentPage.tapSubmitButton()
//
//        XCTAssertEqual(paymentPage.getPaymentStatusMessage(), "Decline")
//    }
//
//    func testSuccessfulPaymentByMasterCard() throws {
//        paymentPage.fillPaymentForm(cardNumber: "340000000001007", month: "1224", cvvInput: "1234")
//        paymentPage.tapSubmitButton()
//
//        XCTAssertEqual(paymentPage.getPaymentStatusMessage(), "Payment has been successfully processed.")
//    }
//
//    func testSuccessfulPaymentByAmexCard() throws {
//        paymentPage.fillPaymentForm(cardNumber: "340000000001007", month: "1224", cvvInput: "1234")
//        paymentPage.tapSubmitButton()
//
//        XCTAssertEqual(paymentPage.getPaymentStatusMessage(), "Payment has been successfully processed.")
//    }
//
//    func testLabelsTranslation() throws {
//        paymentPage.tapSubmitButton()
//
//        XCTAssertEqual(paymentPage.getCreditCardFieldLabel(), "Card number")
//        XCTAssertEqual(paymentPage.getExpDateVFieldLabel(), "Expiration date")
//        XCTAssertEqual(paymentPage.getCvvFieldLabel(), "Security code")
//        XCTAssertEqual(paymentPage.getSubmitButtonLabel(), "Submit")
//    }
//
//    func testPaymentStatusMessageTranslation() throws {
//        paymentPage.fillPaymentForm(cardNumber: "4000000000001026", month: "1224", cvvInput: "123")
//        paymentPage.tapSubmitButton()
//
//        XCTAssertEqual(paymentPage.getPaymentStatusMessage(), "OK")
//    }
//
//    func testCustomizedTranslation() throws {
//        paymentPage.fillPaymentForm(cardNumber: "4000000000001026", month: "1224", cvvInput: "123")
//        paymentPage.tapSubmitButton()
//
//        XCTAssertEqual(paymentPage.getPaymentStatusMessage(), "Well done!")
//    }
}
