import XCTest

/// Store screenshot capture. Each step attaches a full-screen screenshot with a
/// stable ordered name; Scripts/screenshots.sh extracts the attachments from the
/// xcresult bundle into Store/screenshots/. Run via -only-testing:UITests/ScreenshotFlows.
final class ScreenshotFlows: XCTestCase {
    @MainActor
    func testCaptureStoreScreenshots() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["checklist.remaining"].waitForExistence(timeout: 10))
        capture(app, name: "01-home")
    }

    @MainActor
    private func capture(_ app: XCUIApplication, name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
