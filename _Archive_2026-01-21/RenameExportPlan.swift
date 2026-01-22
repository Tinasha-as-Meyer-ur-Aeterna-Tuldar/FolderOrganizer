//
//  RenameExportPlan.swift
//  FolderOrganizer
//

import Foundation

struct RenameExportPlan: Codable {

    let originalURL: URL
    let originalName: String

    /// Export 時点での最終ファイル名
    let renamedName: String

    /// 警告メッセージ（文字列のみ）
    let warnings: [String]
}
