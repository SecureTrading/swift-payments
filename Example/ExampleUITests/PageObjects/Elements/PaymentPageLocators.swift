import Foundation
import XCTest

enum PaymentPageLocators: String {

    //ToDo - Change locators id
    case cardNumberInput = "cardNumberInput"
    case expDateInput = "expDateInput"
    case cvvInput = "cvvInput"
    case submitButton = "submitButton"
    case applePayButton = "applePayButton"
    case panValidationMessage = "panValidationMessage"
    case expDateValidationMessage = "expDateValidationMessage"
    case cvvValidationMessage = "cvvValidationMessage"
    case paymentStatusMessage = "paymentStatusMessage"

    var element: XCUIElement {
        
        switch self {
        case .paymentStatusMessage, .panValidationMessage, .expDateValidationMessage, .cvvValidationMessage:
            return XCUIApplication().staticTexts[self.rawValue]
        case .cardNumberInput, .expDateInput, .cvvInput:
            return XCUIApplication().textFields[self.rawValue]
        case .submitButton, .applePayButton:
            return XCUIApplication().buttons[self.rawValue]
        }
    }
}
