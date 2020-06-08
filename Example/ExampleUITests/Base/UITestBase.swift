import XCTest

class UITestBase: XCTestCase {

    var app = XCUIApplication()
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        //ToDo - temporary link to payment form
        XCUIApplication()/*@START_MENU_TOKEN@*/.staticTexts["show drop in view controller (make auth req)"]/*[[".otherElements[\"home\/view\/main\"]",".buttons[\"show drop in view controller (make auth req)\"].staticTexts[\"show drop in view controller (make auth req)\"]",".staticTexts[\"show drop in view controller (make auth req)\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
}
