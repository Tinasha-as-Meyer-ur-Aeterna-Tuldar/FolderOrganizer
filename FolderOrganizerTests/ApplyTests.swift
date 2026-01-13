import XCTest
@testable import FolderOrganizer

final class ApplyTests: XCTestCase {

    func testApplyMovesItem() {

        let original = TestHelpers.makeTestURL(
            "/tmp/A/[山田太郎] 新作短編集"
        )
        let authorDir = TestHelpers.makeTestURL(
            "/tmp/A/山田太郎"
        )
        let target = authorDir.appendingPathComponent("新作短編集")

        let mockFS = MockFileSystem(initialPaths: [original])
        let applyService = DefaultRenameApplyService(fileSystem: mockFS)

        let plan = TestHelpers.sampleRenamePlan(
            originalURL: original,
            targetParent: authorDir
        )

        let result = applyService.apply(plan)

        XCTAssertTrue(result.success)
        XCTAssertTrue(mockFS.fileExists(at: target))
        XCTAssertFalse(mockFS.fileExists(at: original))
    }
}
