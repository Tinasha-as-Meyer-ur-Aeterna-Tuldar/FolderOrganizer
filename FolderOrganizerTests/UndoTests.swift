import XCTest
@testable import FolderOrganizer

final class UndoTests: XCTestCase {

    func testUndoRestoresOriginalLocation() {

        let original = TestHelpers.makeTestURL(
            "/tmp/A/[山田太郎] 新作短編集"
        )
        let authorDir = TestHelpers.makeTestURL(
            "/tmp/A/山田太郎"
        )
        let target = authorDir.appendingPathComponent("新作短編集")

        let mockFS = MockFileSystem(
            initialPaths: [target]
        )

        let plan = TestHelpers.sampleRenamePlan(
            originalURL: original,
            targetParent: authorDir
        )

        let applyResult = ApplyResult(
            plan: plan,
            success: true,
            appliedURL: target,
            error: nil
        )

        let undoService = DefaultRenameUndoService(
            fileSystem: mockFS
        )

        let undoResult = undoService.undo(applyResult)

        XCTAssertTrue(undoResult.success)
        XCTAssertTrue(mockFS.fileExists(at: original))
        XCTAssertFalse(mockFS.fileExists(at: target))
    }
}
