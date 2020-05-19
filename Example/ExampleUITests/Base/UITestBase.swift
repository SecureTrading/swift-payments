
import XCTest

class UITestBase: XCTestCase {

    var app = XCUIApplication()
    
    // MARK: Setup
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
}
