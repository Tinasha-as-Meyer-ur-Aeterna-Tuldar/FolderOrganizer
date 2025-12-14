import XCTest
@testable import FolderOrganizer

final class DryRunTests: XCTestCase {

    func testDryRunGeneratesRenamePlan() {

        let engine = RenamePlanEngine()
        let url = TestHelpers.makeTestURL(
            "/Downloads/[山田太郎] 新作短編集 DL版"
        )

        let plan = engine.generatePlan(for: url)

        XCTAssertEqual(plan.detectedAuthor, "山田太郎")
        XCTAssertEqual(plan.title, "新作短編集")
        XCTAssertEqual(plan.maybeSubtitle, "DL版")
    }
}
