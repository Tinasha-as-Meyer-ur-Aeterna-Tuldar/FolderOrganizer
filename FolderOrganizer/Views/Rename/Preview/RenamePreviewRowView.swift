//
//  RenamePreviewRowView.swift
//  FolderOrganizer
//

import SwiftUI

struct RenamePreviewRowView: View {

    let item: RenameItem
    let isDiffVisible: Bool
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            // 元の名前
            Text(item.original)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.secondary)

            // 新しい名前
            Text(item.normalized)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(2)

            // Diff 表示（STEP D で拡張予定）
            if isDiffVisible && item.original != item.normalized {
                Text("変更あり")
                    .font(.caption2)
                    .foregroundStyle(.blue)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onEdit()
        }
    }
}
