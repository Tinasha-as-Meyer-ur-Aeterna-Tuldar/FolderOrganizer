// Domain/Export/RenameSessionInfo.swift
//
// Rename セッションのメタ情報（Export 用）
//

import Foundation

struct RenameSessionInfo: Codable {

    let id: UUID
    let rootPath: String

    let scannedAt: Date
    let appliedAt: Date?

    let summary: Summary

    struct Summary: Codable {
        let total: Int
        let changed: Int
        let skipped: Int
    }
}
