// FolderOrganizer/Domain/Browse/FolderNode.swift
//
// フォルダ構造を表すツリーノード
// ・OutlineGroup 用に Optional children を提供
//

import Foundation

struct FolderNode: Identifiable, Hashable {

    let id = UUID()
    let url: URL
    let name: String
    let depth: Int

    var children: [FolderNode] = []
    var fileCount: Int = 0

    // MARK: - OutlineGroup Support

    /// OutlineGroup が要求する Optional children
    var childrenForOutline: [FolderNode]? {
        children.isEmpty ? nil : children
    }
}
