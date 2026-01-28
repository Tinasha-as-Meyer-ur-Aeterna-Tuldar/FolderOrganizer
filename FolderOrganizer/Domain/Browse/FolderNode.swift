// Domain/FolderNode.swift
//
// フォルダツリーのノード
// B-2b: 子ノードを見て親を SERIES に昇格させる fixup を実装
//

import Foundation

final class FolderNode: Identifiable {

    let id = UUID()
    let name: String
    let url: URL
    let fileCount: Int

    var roleHint: FolderRoleHint
    var children: [FolderNode]

    init(
        name: String,
        url: URL,
        fileCount: Int,
        roleHint: FolderRoleHint,
        children: [FolderNode] = []
    ) {
        self.name = name
        self.url = url
        self.fileCount = fileCount
        self.roleHint = roleHint
        self.children = children
    }

    // MARK: - OutlineGroup 用
    var childrenForOutline: [FolderNode]? {
        children.isEmpty ? nil : children
    }

    // MARK: - B-2b: 親フォルダ昇格ロジック
    func fixupRoleFromChildren() {

        // 先に子を fixup
        for child in children {
            child.fixupRoleFromChildren()
        }

        // 自分が UNKNOWN のときのみ再判定
        guard roleHint == .unknown else { return }

        // 子に VOLUME が1つでもあれば SERIES
        if children.contains(where: { $0.roleHint == .volume }) {
            roleHint = .series
        }
    }
}
