// Views/Apply/ApplySummary.swift
//
// Apply 結果サマリ（v0.2 UX 共通モデル）
// ・ApplyResultList / ApplySummaryView 両方で使用
//

import SwiftUI

struct ApplySummary {

    let title: String
    let detail: String?
    let color: Color

    init(results: [ApplyResult]) {

        let success = results.filter { $0.isSuccess }.count
        let failure = results.filter { $0.error != nil }.count

        // 🔴 failure 優先
        if failure > 0 {
            title = "一部の変更に失敗しました"
            detail = "詳細を確認してください"
            color = .red
            return
        }

        // 🟢 success
        if success > 0 {
            title = "変更を適用しました"
            detail = "\(success) 件の変更を適用しました"
            color = .green
            return
        }

        // 🟡 空 or 全スキップ = 正常終了
        title = "変更対象はありませんでした"
        detail = "すべての項目は変更不要でした"
        color = .yellow
    }
}
