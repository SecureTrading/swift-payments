import XCTest

open class PaymentPage {

    // MARK: Actions
    public func fillCardNumberInput(cardNumber: String) {
        PaymentPageLocators.cardNumberInput.element.tap()
        PaymentPageLocators.cardNumberInput.element.typeText(cardNumber)
    }
    
    public func fillExpDateInput(expDate: String) {
        PaymentPageLocators.expDateInput.element.tap()
        PaymentPageLocators.expDateInput.element.typeText(expDate)
    }
    
    public func fillCvvInput(cvvInput: String) {
        PaymentPageLocators.cvvInput.element.tap()
        PaymentPageLocators.cvvInput.element.typeText(cvvInput)
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
    
    func getPanValidationMessage() -> String {
        return PaymentPageLocators.panValidationMessage.element.label
    }
    
    func getExpDateValidationMessage() -> String {
        return PaymentPageLocators.expDateValidationMessage.element.label
    }
    
    func getCvvValidationMessage() -> String {
        return PaymentPageLocators.cvvValidationMessage.element.label
    }
}
