import XCTest

class UITestBase: XCTestCase {

    var app = XCUIApplication()
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        //ToDo - temporary link to payment form
        XCUIApplication().staticTexts["Pay by Card form (no 3DSecure)"].tap()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
}
