import XCTest

extension XCTestCase {
    func takeScreenshot(of element: XCUIElement, name: String) {
        let screenshot = element.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        add(attachment)
    }
}
