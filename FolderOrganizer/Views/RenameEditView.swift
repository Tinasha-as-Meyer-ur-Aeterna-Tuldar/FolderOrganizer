// Views/RenameEditView.swift
import SwiftUI

struct RenameEditView: View {

    let original: String
    @Binding var edited: String

    let onCommit: () -> Void
    let onCancel: () -> Void

    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: 16) {

            Text("名前を編集")
                .font(.headline)

            // ─────────────────────────
            // リアルタイムプレビュー（色付きスペース）
            // ─────────────────────────
            VStack(alignment: .leading, spacing: 6) {
                Text("プレビュー（編集内容が即時反映）")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(
                    SpaceMarkerText.make(
                        edited.isEmpty ? original : edited
                    )
                )
                .font(.system(size: 15, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
                .padding(10)
                .background(AppTheme.colors.previewBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AppTheme.colors.previewBorder)
                )
                .cornerRadius(6)
            }

            // ─────────────────────────
            // 編集欄（生テキスト）
            // ─────────────────────────
            GroupBox("編集") {
                TextEditor(text: $edited)
                    .font(.system(size: 18, design: .monospaced))
                    .frame(minHeight: 120)
                    .padding(6)
                    .background(AppTheme.colors.cardBackground)
                    .cornerRadius(6)
                    .focused($focused)
            }

            HStack {
                Button("キャンセル") { onCancel() }
                Spacer()
                Button("反映") { onCommit() }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .frame(minWidth: 520, idealWidth: 600, maxWidth: 640)
        .frame(minHeight: 380)
        .focusable(true)
        .onAppear { focused = true }

        .onKeyPress(.return) {
            onCommit()
            return .handled
        }

        .onKeyPress(.escape) {
            onCancel()
            return .handled
        }
    }
}
