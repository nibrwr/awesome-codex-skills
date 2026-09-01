import XCTest

extension XCTestCase {
    /// Saves a full-screen UI-test capture using the lowercase kebab-case shot ID
    /// declared in AppStore/screenshots.json, for example `01-core-value`.
    @MainActor
    func attachAppStoreScreenshot(named shotID: String) {
        let pattern = #"^\d{2}-[a-z0-9]+(?:-[a-z0-9]+)*$"#
        let range = NSRange(shotID.startIndex..., in: shotID)
        precondition(
            try! NSRegularExpression(pattern: pattern).firstMatch(
                in: shotID,
                range: range
            ) != nil,
            "App Store screenshot IDs must use a two-digit prefix and lowercase kebab-case."
        )

        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = "\(shotID).png"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
