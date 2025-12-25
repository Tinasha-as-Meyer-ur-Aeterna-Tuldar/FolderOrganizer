//
// Views/Rename/Preview/RenamePreviewRowView.swift
// Preview 一覧の1行
// Diff 表示 ON / OFF 対応
//

import SwiftUI

struct RenamePreviewRowView: View {

    let item: RenameItem
    let showSpaceMarkers: Bool
    let isDiffVisible: Bool
    let onEdit: () -> Void

    /// 等幅フォント（Diff 前提）
    private let baseFont: Font = .system(
        size: 13,
        weight: .regular,
        design: .monospaced
    )

    var body: some View {
        HStack(spacing: 12) {

            // flagged マーク
            if item.flagged {
                Image(systemName: "flag.fill")
                    .foregroundColor(.orange)
            }

            VStack(alignment: .leading, spacing: 4) {

                // 元の名前
                SpaceMarkerTextView(
                    item.original,
                    showSpaceMarkers: showSpaceMarkers,
                    font: baseFont
                )
                .opacity(0.6)

                // 変更後表示
                if isDiffVisible {
                    DiffTextView(
                        tokens: diffTokens,
                        font: baseFont
                    )
                } else {
                    SpaceMarkerTextView(
                        previewName,
                        showSpaceMarkers: showSpaceMarkers,
                        font: baseFont
                    )
                }
            }

            Spacer()

            Button("編集") {
                onEdit()
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Helpers

    private var previewName: String {
        item.edited.isEmpty ? item.normalized : item.edited
    }

    private var diffTokens: [DiffToken] {
        DiffBuilder.build(
            original: item.original,
            modified: previewName
        )
    }
}
