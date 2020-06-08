import Foundation
import XCTest

enum PaymentPageLocators: String {

    //ToDo - Change locators id
    case cardNumberInput = "st-card-number-input-textfield"
    case monthInput = "st-expiration-date-input-month-textfield"
    case yearInput = "st-expiration-date-input-year-textfield"
    case cvvInput = "st-security-code-input-textfield"
    case submitButton = "submitButton"
    case applePayButton = "applePayButton"
    case creditCardValidationMessage = "st-card-number-message"
    case expDateValidationMessage = "st-expiration-date-message"
    case cvvValidationMessage = "st-security-code-input-message"
    case paymentStatusMessage = "paymentStatusMessage"
    case cardNumberFieldLabel = "cardNumberFieldLabel"
    case expDateFieldLabel = "expDateFieldLabel"
    case cvvFieldLabel = "cvvFieldLabel"

    var element: XCUIElement {
        
        switch self {
        case .paymentStatusMessage, .creditCardValidationMessage, .expDateValidationMessage, .cvvValidationMessage, .cardNumberFieldLabel, .expDateFieldLabel, .cvvFieldLabel:
            return XCUIApplication().staticTexts[self.rawValue]
        case .cardNumberInput, .monthInput, .yearInput:
            return XCUIApplication().textFields[self.rawValue]
        case .cvvInput:
            return XCUIApplication().secureTextFields[self.rawValue]
        case .submitButton, .applePayButton:
            return XCUIApplication().buttons[self.rawValue]
        }
    }
}
