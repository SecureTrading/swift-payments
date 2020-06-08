import XCTest

open class PaymentPage {

    // MARK: Actions
    public func fillPaymentForm(cardNumber: String, month: String, cvvInput: String) {
        fillCardNumberInput(cardNumber: cardNumber)
        fillMonthInput(month: month)
        fillCvvInput(cvvInput: cvvInput)
    }
    
    public func fillCardNumberInput(cardNumber: String) {
        PaymentPageLocators.cardNumberInput.element.tap()
        PaymentPageLocators.cardNumberInput.element.typeText(cardNumber)
        PaymentPageLocators.cardNumberInput.element.typeText("\n")
    }
    
    public func fillMonthInput(month: String) {
        PaymentPageLocators.monthInput.element.tap()
        PaymentPageLocators.monthInput.element.typeText(month)
    }
    
    public func fillYearInput(year: String) {
        PaymentPageLocators.yearInput.element.tap()
        PaymentPageLocators.yearInput.element.typeText(year)
        PaymentPageLocators.yearInput.element.typeText("\n")
    }
    
    public func fillCvvInput(cvvInput: String) {
        PaymentPageLocators.cvvInput.element.tap()
        PaymentPageLocators.cvvInput.element.typeText(cvvInput)
        PaymentPageLocators.cvvInput.element.typeText("\n")
    }
    
    public func tapOnCreditCardInput() {
        PaymentPageLocators.cardNumberInput.element.tap()
    }
    
    public func tapOnYearInput() {
        PaymentPageLocators.yearInput.element.tap()
    }
    
    public func tapOnCvvInput() {
        PaymentPageLocators.cvvInput.element.tap()
    }

    public func tapSubmitButton() {
        PaymentPageLocators.submitButton.element.tap()
    }
    
    public func tapApplePayButton() {
        PaymentPageLocators.applePayButton.element.tap()
    }
    
    // MARK: Helpers
    func getPaymentStatusMessage() -> String {
        return PaymentPageLocators.paymentStatusMessage.element.label
    }
    
    func getCreditCardValidationMessage() -> String {
        return PaymentPageLocators.creditCardValidationMessage.element.label
    }
    
    func getExpDateValidationMessage() -> String {
        return PaymentPageLocators.expDateValidationMessage.element.label
    }
    
    func getCvvValidationMessage() -> String {
        return PaymentPageLocators.cvvValidationMessage.element.label
    }
    
    func getCreditCardFieldLabel() -> String {
        return PaymentPageLocators.cardNumberFieldLabel.element.label
    }
    
    func getExpDateVFieldLabel() -> String {
        return PaymentPageLocators.expDateFieldLabel.element.label
    }
    
    func getCvvFieldLabel() -> String {
        return PaymentPageLocators.cvvFieldLabel.element.label
    }
    func getSubmitButtonLabel() -> String {
        return PaymentPageLocators.submitButton.element.label
    }
    
    func isCvvFieldEnabled() -> Bool {
        return PaymentPageLocators.cvvInput.element.isEnabled
    }
    
    func isSubmitButtonEnabled() -> Bool {
        return PaymentPageLocators.submitButton.element.isEnabled
    }
}
