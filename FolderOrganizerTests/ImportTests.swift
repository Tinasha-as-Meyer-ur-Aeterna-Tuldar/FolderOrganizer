import XCTest
@testable import FolderOrganizer

final class ImportTests: XCTestCase {

    func testImportRenamePlanAndRedryRun() throws {

        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("renamePlan.json")

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
        try data.write(to: tempURL)

        let importService = ImportService()
        let engine = RenamePlanEngine()

        let urls = try importService.importRenamePlans(from: tempURL)
        let redryPlan = engine.generatePlan(for: urls.first!)

        XCTAssertEqual(redryPlan.title, "新作短編集")
    }
}
