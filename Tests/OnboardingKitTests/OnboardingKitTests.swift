import XCTest
@testable import OnboardingKit

final class OnboardingKitTests: XCTestCase {
    func testReplaceVariablesUsesApplicationMetadata() {
        let helper = OnboardingKitHelper(bundle: .main)

        let result = helper.replaceVariables(
            in: "%APP_NAME% %APP_VERSION% %APP_BUILD%"
        )

        XCTAssertFalse(result.contains("%APP_NAME%"))
        XCTAssertFalse(result.contains("%APP_VERSION%"))
        XCTAssertFalse(result.contains("%APP_BUILD%"))
    }

    func testReplaceVariablesLeavesUnknownVariablesUnchanged() {
        let helper = OnboardingKitHelper(bundle: .main)

        XCTAssertEqual(
            helper.replaceVariables(in: "%UNKNOWN%"),
            "%UNKNOWN%"
        )
    }
}
