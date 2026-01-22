// Views/Rename/Edit/RenameEditView.swift
import SwiftUI

struct RenameEditView: View {

    @ObservedObject var session: RenameSession

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ZStack {
            // 背景（編集モードの暗幕）
            Color.black.opacity(0.25)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Text("Editing")
                    .font(.headline)

                TextField("New name", text: $session.editingText)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 360)
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        // Enter = 確定（STEP C/D では「編集終了」だけ）
                        session.finishEditing()
                    }

                Text("Enter: 確定 / Esc: キャンセル")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
        .overlay(escapeCancelButton) // ← Esc を受け取る
        .onAppear {
            // 表示直後にフォーカス（Enter/入力がすぐ効く）
            isTextFieldFocused = true
        }
    }

    /// Esc キーでキャンセルするための「見えないボタン」
    private var escapeCancelButton: some View {
        Button {
            session.cancelEditing()
        } label: {
            EmptyView()
        }
        .keyboardShortcut(.escape, modifiers: [])
        .hidden()
    }
}
