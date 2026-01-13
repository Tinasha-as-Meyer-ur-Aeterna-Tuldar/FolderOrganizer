// Views/Apply/ApplyResultList.swift
//
// Apply 結果一覧（v0.2 UX）
// ・空結果も「変更なし」として扱う
//

import SwiftUI

struct ApplyResultList: View {

    let results: [ApplyResult]

    private var summary: ApplySummary {
        ApplySummary(results: results)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // ===== 状態ヘッダ =====
            HStack(spacing: 10) {
                Circle()
                    .fill(summary.color)
                    .frame(width: 12, height: 12)

                VStack(alignment: .leading, spacing: 2) {
                    Text(summary.title)
                        .font(.headline)

                    if let detail = summary.detail {
                        Text(detail)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Divider()

            // ===== 詳細一覧 =====
            if results.isEmpty {
                EmptyView()
            } else {
                ForEach(results) { result in
                    ApplyResultRow(result: result)
                }
            }
        }
    }
}

