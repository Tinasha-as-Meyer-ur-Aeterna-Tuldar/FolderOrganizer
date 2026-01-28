// FolderOrganizer/Domain/Browse/FolderTreeBuilder.swift
//
// フォルダツリー構築（B-2 / C-1）
// - フォルダ配下を走査し、FolderNode ツリーを作る
// - B-2a: 役割推定（フォルダ名から VOLUME を推定、他は UNKNOWN）
// - B-2b: 親フォルダ昇格（子を見て UNKNOWN→SERIES）
// - C-1 : 確信度付与（最小）
//

import Foundation

final class FolderTreeBuilder {

    // MARK: - Public

    func buildTree(from rootURL: URL) throws -> FolderNode {
        var root = try buildNode(url: rootURL, parentRole: nil)

        // B-2b: 子を見て親を昇格
        root.fixupRoleFromChildren()

        // C-1: 確信度（最小）
        root.fixupConfidence(parentRoleHint: nil)

        return root
    }

    // MARK: - Core

    private func buildNode(
        url: URL,
        parentRole: FolderRoleHint?
    ) throws -> FolderNode {

        let fm = FileManager.default
        let name = url.lastPathComponent

        // B-2a: 役割推定（最小）
        let role = inferRole(name: name, parentRole: parentRole)

        // 配下を列挙（フォルダのみ child node、ファイルは fileCount に加算）
        let items = (try? fm.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.isDirectoryKey, .isHiddenKey],
            options: [.skipsHiddenFiles]
        )) ?? []

        var children: [FolderNode] = []
        children.reserveCapacity(items.count)

        var fileCount = 0

        for item in items {
            let values = try item.resourceValues(forKeys: [.isDirectoryKey, .isHiddenKey])

            if values.isHidden == true {
                continue
            }

            if values.isDirectory == true {
                let child = try buildNode(url: item, parentRole: role)
                children.append(child)
            } else {
                fileCount += 1
            }
        }

        return FolderNode(
            name: name,
            url: url,
            fileCount: fileCount,
            roleHint: role,
            confidence: .low, // C-1 で後から fixup
            children: children.isEmpty ? nil : children
        )
    }

    // MARK: - B-2a: Role Inference (Minimal)

    private func inferRole(name: String, parentRole: FolderRoleHint?) -> FolderRoleHint {
        // 「第01巻」「第1巻」「第01-06巻」「v01」「v01-06」などを VOLUME 扱い（最小）
        if looksLikeVolume(name) {
            return .volume
        }

        // それ以外は UNKNOWN（B-2b で SERIES に昇格し得る）
        return .unknown
    }

    private func looksLikeVolume(_ name: String) -> Bool {
        let patterns: [String] = [
            #"第\s*\d+\s*巻"#,          // 第01巻 / 第1巻
            #"第\s*\d+\s*-\s*\d+\s*巻"#, // 第01-06巻
            #"\bv\d{1,3}\b"#,           // v01
            #"\bv\d{1,3}\s*-\s*v?\d{1,3}\b"# // v01-06 / v01-v06
        ]

        for p in patterns {
            if name.range(of: p, options: [.regularExpression, .caseInsensitive]) != nil {
                return true
            }
        }
        return false
    }
}
