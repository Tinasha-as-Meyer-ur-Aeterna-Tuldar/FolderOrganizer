// FolderOrganizer/Services/FolderTreeBuilder.swift
//
// フォルダURLから FolderNode のツリーを構築する
// ・フォルダのみをノード化
// ・ファイルは件数のみ保持
//

import Foundation

final class FolderTreeBuilder {

    private let fileManager = FileManager.default

    // MARK: - Public

    func buildTree(from rootURL: URL) -> FolderNode {
        buildNode(url: rootURL, depth: 0)
    }

    // MARK: - Private

    private func buildNode(url: URL, depth: Int) -> FolderNode {
        var node = FolderNode(
            url: url,
            name: url.lastPathComponent,
            depth: depth
        )

        guard let contents = try? fileManager.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else {
            return node
        }

        for item in contents {
            let isDirectory = (try? item.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) ?? false

            if isDirectory {
                let child = buildNode(url: item, depth: depth + 1)
                node.children.append(child)
            } else {
                node.fileCount += 1
            }
        }

        // 表示安定用に名前順
        node.children.sort { $0.name < $1.name }

        return node
    }
}
