// FolderOrganizer/Views/Rename/Preview/PreviewListContentView.swift
//
// RenamePlan 一覧 + 選択 + インライン編集（v0.2 最終）
// 編集状態はこの View が一元管理する
//

import SwiftUI

struct PreviewListContentView: View {

    // MARK: - Input

    let plans: [RenamePlan]
    let selectionIndex: Int?
    let showSpaceMarkers: Bool

    let onSelect: (Int) -> Void
    let onCommit: (Int, String) -> Void

    // MARK: - Editing State（ここが今回の修正点）

    @State private var editingIndex: Int? = nil
    @State private var editingText: String = ""

    // MARK: - Body

    var body: some View {
        List {
            ForEach(plans.indices, id: \.self) { index in
                RenamePreviewRowView(
                    plan: plans[index],
                    isSelected: selectionIndex == index,
                    showSpaceMarkers: showSpaceMarkers,

                    isEditing: editingIndex == index,
                    editingText: $editingText,

                    onRequestEdit: {
                        startEditing(index)
                    },
                    onCommit: { newName in
                        commitEditing(index, newName)
                    },
                    onCancel: {
                        cancelEditing()
                    }
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    onSelect(index)
                }
                .listRowBackground(
                    selectionIndex == index
                    ? Color.accentColor.opacity(0.15)
                    : Color.clear
                )
            }
        }
        .listStyle(.plain)
    }

    // MARK: - Editing Control

    private func startEditing(_ index: Int) {
        editingIndex = index
        editingText = plans[index].normalizedName
    }

    private func commitEditing(_ index: Int, _ newName: String) {
        editingIndex = nil
        onCommit(index, newName)
    }

    private func cancelEditing() {
        editingIndex = nil
    }
}
