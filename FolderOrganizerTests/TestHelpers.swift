import Foundation
@testable import FolderOrganizer

enum TestHelpers {

    static func makeTestURL(_ path: String) -> URL {
        URL(fileURLWithPath: path)
    }

    static func sampleRenamePlan(
        originalURL: URL,
        targetParent: URL
    ) -> RenamePlan {

        RenamePlan(
            originalURL: originalURL,
            originalName: originalURL.lastPathComponent,
            normalizedName: originalURL.lastPathComponent,
            detectedAuthor: "山田太郎",
            title: "新作短編集",
            subtitle: nil,
            maybeSubtitle: nil,
            targetParentFolder: targetParent,
            targetName: "新作短編集",
            warnings: []
        )
    }
}
