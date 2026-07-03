import XCTest

/// Smoke flow: the app launches and the core screen is interactive.
/// Gate id: ui_smoke.
final class SmokeTests: XCTestCase {
    @MainActor
    func testLaunchAndAddItem() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["checklist.remaining"].waitForExistence(timeout: 10))

        let input = app.textFields["checklist.input"]
        XCTAssertTrue(input.waitForExistence(timeout: 5))
        input.tap()
        input.typeText("Smoke test item")
        app.buttons["checklist.add"].tap()

        XCTAssertTrue(app.staticTexts["Smoke test item"].waitForExistence(timeout: 5))
    }
}
