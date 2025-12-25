//
// Views/Rename/Preview/PreviewRowView.swift
// Preview 表示行（RenamePreviewRowView の薄いラッパー）
// Session の状態（Diff 表示）に追従
//

import SwiftUI

struct PreviewRowView: View {

    let item: RenameItem
    let index: Int
    let isSelected: Bool

    let showSpaceMarkers: Bool
    let isDiffVisible: Bool          // ← ★ 追加

    @Binding var flagged: Bool

    let onSelect: () -> Void

    var body: some View {
        RenamePreviewRowView(
            item: item,
            showSpaceMarkers: showSpaceMarkers,
            isDiffVisible: isDiffVisible,   // ← ★ ここが不足していた
            onEdit: onSelect
        )
    }
}
