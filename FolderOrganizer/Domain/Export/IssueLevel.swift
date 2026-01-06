//
//  IssueLevel.swift
//  FolderOrganizer
//

import Foundation

/// Export / Preflight / UI 共通で使用する Issue レベル
enum IssueLevel: String, Codable, Hashable, CaseIterable {

    /// 致命的エラー（Apply 不可）
    case error

    /// 警告（Apply 可能だが注意）
    case warning

    /// 情報（参考表示のみ）
    case info
}
