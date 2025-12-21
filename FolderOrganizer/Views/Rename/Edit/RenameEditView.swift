// Views/RenameEditView.swift
import SwiftUI

struct RenameEditView: View {
    let item: RenameItem
    let showSpaceMarkers: Bool
    let onApply: (RenameItem) -> Void
    let onCancel: () -> Void

    @State private var editingText: String = ""

    init(
        item: RenameItem,
        showSpaceMarkers: Bool,
        onApply: @escaping (RenameItem) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.item = item
        self.showSpaceMarkers = showSpaceMarkers
        self.onApply = onApply
        self.onCancel = onCancel
        _editingText = State(initialValue: item.displayNameForList)
    }

    var body: some View {
        VStack(spacing: 16) {

            // プレビュー
            VStack(alignment: .leading, spacing: 6) {
                Text("プレビュー")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                SpaceMarkerTextView(
                    editingText,
                    showSpaceMarkers: showSpaceMarkers,
                    font: .system(size: 14, weight: .semibold, design: .monospaced)
                )
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            // 編集
            VStack(alignment: .leading, spacing: 6) {
                Text("編集")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                TextEditor(text: $editingText)
                    .font(.system(size: 14))
                    .frame(minHeight: 240)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4))
                    )
            }

            HStack {
                Button("キャンセル") { onCancel() }
                Spacer()
                Button("反映") {
                    var updated = item
                    updated.edited = editingText
                    onApply(updated)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(18)
        .frame(minWidth: 700, minHeight: 520)
    }
}
