import XCTest
@testable import FolderOrganizer

final class ExportTests: XCTestCase {

    func testExportRenamePlanToJSON() throws {

        let plan = TestHelpers.sampleRenamePlan(
            originalURL: TestHelpers.makeTestURL(
                "/Downloads/[山田太郎] 新作短編集"
            ),
            targetParent: TestHelpers.makeTestURL(
                "/Downloads/山田太郎"
            )
        )

        let export = RenamePlanExport(from: plan)

        let encoder = ExportEncoder.makeJSONEncoder()
        let data = try encoder.encode([export])

        XCTAssertFalse(data.isEmpty)
    }
}
