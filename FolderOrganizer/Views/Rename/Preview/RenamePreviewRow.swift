// Views/Rename/Preview/RenamePreviewRow.swift
//
// RenamePlan 1件分のプレビュー行
// 変更あり/なしのアイコン表示、原名→正規化名、warnings を表示する
//

import SwiftUI

struct RenamePreviewRow: View {

    // MARK: - Input
    let plan: RenamePlan

    // MARK: - Body
    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            // 差分アイコン
            Image(systemName: plan.originalName == plan.normalizedName
                  ? "minus.circle"
                  : "arrow.right.circle.fill")
            .foregroundStyle(plan.originalName == plan.normalizedName
                             ? Color.secondary
                             : Color.blue)

            VStack(alignment: .leading, spacing: 4) {

                Text(plan.originalName)
                    .font(.system(size: 12, design: .monospaced))

                Text("→ \(plan.normalizedName)")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(plan.originalName == plan.normalizedName
                                     ? Color.secondary
                                     : Color.primary)

                // Warning 表示
                if !plan.normalizeResult.warnings.isEmpty {
                    ForEach(plan.normalizeResult.warnings, id: \.self) { warning in
                        Text("⚠ \(warning)")
                            .font(.caption)
                            .foregroundStyle(.orange)
                    }
                }
            }

            Spacer()
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(NSColor.windowBackgroundColor))
        )
    }
}
