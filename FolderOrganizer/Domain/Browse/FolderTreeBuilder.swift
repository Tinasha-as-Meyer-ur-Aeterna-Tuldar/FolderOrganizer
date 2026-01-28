// Domain/FolderTreeBuilder.swift
//
// フォルダ構造を FolderNode ツリーに変換
// B-2a: inferRole
// B-2b: build 後に親フォルダ昇格 fixup
//

import Foundation

final class FolderTreeBuilder {

    // MARK: - Public

    func buildTree(from rootURL: URL) throws -> FolderNode {
        let root = try buildNode(
            url: rootURL,
            parentRole: nil
        )

        // ★ B-2b：子を見て親を昇格
        root.fixupRoleFromChildren()

        return root
    }

    // MARK: - Core

    private func buildNode(
        url: URL,
        parentRole: FolderRoleHint?
    ) throws -> FolderNode {

        let fileManager = FileManager.default
        let name = url.lastPathComponent

        // 役割推定（B-2a）
        let role = inferRole(
            name: name,
            parentRole: parentRole
        )

        // 子フォルダ取得
        let childURLs = (try? fileManager.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )) ?? []

        var children: [FolderNode] = []

        for childURL in childURLs {
            let values = try childURL.resourceValues(forKeys: [.isDirectoryKey])
            guard values.isDirectory == true else { continue }

            let childNode = try buildNode(
                url: childURL,
                parentRole: role
            )
            children.append(childNode)
        }

        let fileCount = children.count

        return FolderNode(
            name: name,
            url: url,
            fileCount: fileCount,
            roleHint: role,
            children: children
        )
    }

    // MARK: - B-2a: inferRole
    private func inferRole(
        name: String,
        parentRole: FolderRoleHint?
    ) -> FolderRoleHint {

        // 巻数っぽい名前 → VOLUME
        if name.range(of: #"第\d+巻"#, options: .regularExpression) != nil {
            return .volume
        }

        // 親が SERIES なら、その子は VOLUME 候補
        if parentRole == .series {
            return .volume
        }

        return .unknown
    }
}
