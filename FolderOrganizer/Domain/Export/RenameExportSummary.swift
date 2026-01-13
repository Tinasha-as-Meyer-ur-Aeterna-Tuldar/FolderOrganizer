//
//  RenameExportSummary.swift
//  FolderOrganizer
//

import Foundation

/// Export 用のサマリー（件数集計やブロッキング判定に使う）
///
/// - ここは View で表示する「件数」や「実行可否」の判断材料をまとめる役割
/// - `issues` の severity（level）を元に集計する
struct RenameExportSummary: Codable {

    // Export 結果にぶら下がる issue 一覧
    let issues: [RenameExportIssue]

    // 将来拡張：ユーザーが手編集した数（現状は 0 固定でOK）
    var userEditedCount: Int { 0 }

    /// “flagged” の定義：
    /// - 現状は issues の総数でOK（warning + error + info の合計）
    /// - 将来「warning 以上」だけにする等の調整余地あり
    var flaggedCount: Int { issues.count }

    /// warning 件数
    var warningCount: Int {
        issues.filter { $0.level == .warning }.count
    }

    /// error 件数
    var errorCount: Int {
        issues.filter { $0.level == .error }.count
    }

    /// Apply を止めるべきか（error が 1つでもあれば止める）
    var hasBlockingErrors: Bool {
        issues.contains(where: { $0.level == .error })
    }
}
