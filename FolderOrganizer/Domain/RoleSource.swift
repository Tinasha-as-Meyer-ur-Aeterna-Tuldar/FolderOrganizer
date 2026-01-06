//
//  RoleSource.swift
//  FolderOrganizer
//

import Foundation

enum RoleSource: String, Codable, Hashable {
    case detected      // 自動検出
    case userEdited    // ユーザー編集
    case imported      // Import 由来
}
