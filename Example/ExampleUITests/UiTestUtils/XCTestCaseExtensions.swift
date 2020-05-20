import XCTest

extension XCTestCase {
    
    /// Take screenshot method
    /// - Parameters:
    ///   - element: element from current view
    ///   - name: name of screenshot file
    func takeScreenshot(of element: XCUIElement, name: String) {
        let screenshot = element.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        add(attachment)
    }
}
