// FolderOrganizer/Views/Rename/Preview/RenamePreviewList.swift
//
// プレビュー一覧（選択 + 編集 + Apply 入口）
// - ContentView から渡される plans / selectionIndex / showSpaceMarkers を受ける
// - List(selection:) を Binding<Int?> で動かし、上下キー移動を成立させる
// - Enter = 編集開始（ボタンに keyboardShortcut を割り当て）
// - 編集確定（Enter）で onCommit(index, newName) を呼び、上位（state）へ反映させる
//

import SwiftUI

struct RenamePreviewList: View {

    // MARK: - Inputs

    let plans: [RenamePlan]
    @Binding var selectionIndex: Int?
    let showSpaceMarkers: Bool

    /// 編集確定（index と newName を返す）
    let onCommit: (Int, String) -> Void

    /// Apply 実行へ
    let onApply: () -> Void

    /// 閉じる（Welcome に戻る等）
    let onCancel: () -> Void

    // MARK: - Local UI State

    @State private var editingIndex: Int? = nil
    @State private var editingText: String = ""

    @FocusState private var isEditorFocused: Bool
    @FocusState private var isListFocused: Bool

    // MARK: - View

    var body: some View {
        VStack(spacing: 0) {

            header

            Divider()

            listBody

            Divider()

            footer
        }
        .onAppear {
            // 初回にフォーカスが無いと上下キーが効かないことがあるため
            DispatchQueue.main.async {
                isListFocused = true
                if selectionIndex == nil, !plans.isEmpty {
                    selectionIndex = 0
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("Apply Preview")
                .font(.headline)

            Spacer()

            // Enter で編集開始
            Button("編集") {
                beginEditingSelected()
            }
            .keyboardShortcut(.return, modifiers: [])
            .disabled(selectionIndex == nil || plans.isEmpty)

            // Cmd+Enter で Apply（誤操作を避けつつキーボード操作も可能に）
            Button("適用") {
                onApply()
            }
            .keyboardShortcut(.return, modifiers: [.command])
            .disabled(plans.isEmpty)

            Button("閉じる") {
                onCancel()
            }
            .keyboardShortcut(.escape, modifiers: [])
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    // MARK: - List

    private var listBody: some View {
        List(selection: $selectionIndex) {
            ForEach(plans.indices, id: \.self) { index in
                RenamePreviewRowView(
                    plan: plans[index],
                    isSelected: selectionIndex == index,
                    showSpaceMarkers: showSpaceMarkers,
                    isEditing: editingIndex == index,
                    editingText: $editingText,
                    onRequestEdit: {
                        selectionIndex = index
                        beginEditing(index: index)
                    },
                    onCommit: { newName in
                        commitEditing(index: index, newName: newName)
                    },
                    onCancel: {
                        cancelEditing()
                    }
                )
                .tag(index)
                .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            }
        }
        .listStyle(.plain)
        .focused($isListFocused)
        .onChange(of: selectionIndex) { _, newValue in
            // 選択が変わったら、編集中ならキャンセル（安全側）
            // 「選択移動しつつ編集を維持」は次の改善でやれる
            guard let newValue else { return }
            if let editingIndex, editingIndex != newValue {
                cancelEditing()
            }
        }
    }

    // MARK: - Footer

    private var footer: some View {
        HStack(spacing: 10) {
            Text(plans.isEmpty ? "対象がありません" : "\(plans.count) 件")
                .foregroundStyle(.secondary)

            Spacer()

            // 現状：スペースマーカー ON/OFF は上位の state が持つ（showSpaceMarkers）
            // ここでは表示のみ（将来ここにトグルを置くなら Binding を追加）
            if showSpaceMarkers {
                Text("スペース表示: ON")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("スペース表示: OFF")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    // MARK: - Editing Control

    private func beginEditingSelected() {
        guard let index = selectionIndex else { return }
        beginEditing(index: index)
    }

    private func beginEditing(index: Int) {
        guard plans.indices.contains(index) else { return }

        editingIndex = index
        editingText = plans[index].normalizedName

        // TextField にフォーカス
        DispatchQueue.main.async {
            isEditorFocused = true
        }
    }

    private func commitEditing(index: Int, newName: String) {
        guard plans.indices.contains(index) else { return }

        editingIndex = nil
        isEditorFocused = false

        onCommit(index, newName)
    }

    private func cancelEditing() {
        editingIndex = nil
        isEditorFocused = false
    }
}
