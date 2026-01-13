// Views/Apply/ApplySummaryView.swift
//
// メイン画面用 Apply 状態サマリ（常時表示）
// ・Apply 前後の状態が一目で分かる
//

import SwiftUI

struct ApplySummaryView: View {

    let results: [ApplyResult]?

    private var summary: ApplySummary? {
        guard let results else { return nil }
        return ApplySummary(results: results)
    }

    var body: some View {
        HStack(spacing: 8) {

            if let summary {
                Circle()
                    .fill(summary.color)
                    .frame(width: 8, height: 8)

                Text(summary.title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Text("未実行")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}
