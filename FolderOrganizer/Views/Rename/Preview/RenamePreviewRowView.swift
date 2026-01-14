// FolderOrganizer/Views/Rename/Preview/RenamePreviewRowView.swift
//
// 1行表示 + インライン編集（Binding 対応版 v0.2）
//

import SwiftUI

struct RenamePreviewRowView: View {

    let plan: RenamePlan
    let isSelected: Bool
    let showSpaceMarkers: Bool

    // 編集状態（親が制御）
    let isEditing: Bool
    let editingText: Binding<String>

    // Actions
    let onRequestEdit: () -> Void
    let onCommit: (String) -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            if isEditing {
                TextField("", text: editingText)
                    .textFieldStyle(.plain)
                    .font(.system(.body, design: .monospaced))
                    .onSubmit {
                        onCommit(editingText.wrappedValue)
                    }
                    .onExitCommand {
                        onCancel()
                    }
            } else {
                DiffTextView(
                    original: plan.originalName,
                    normalized: plan.normalizedName,
                    showSpaceMarkers: showSpaceMarkers
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    onRequestEdit()
                }
            }
        }
        .padding(.vertical, 4)
        .background(isSelected ? Color.accentColor.opacity(0.15) : .clear)
    }
}
