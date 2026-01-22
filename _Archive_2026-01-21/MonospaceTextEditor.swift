//
//  MonospaceTextEditor.swift
//  FolderOrganizer
//

import SwiftUI

struct MonospaceTextEditor: View {

    @Binding var text: String
    var onCommit: () -> Void
    var onCancel: () -> Void

    var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 16, design: .monospaced))
            .foregroundColor(.black)
            .scrollContentBackground(.hidden)   // TextEditor のデフォルト背景を消す
            .background(Color.white)             // 独自背景
            .padding(8)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .onAppear {
                moveCursorToEnd()
            }

            // Enterキー → 確定
            .onKeyPress(.return) {
                onCommit()
                return KeyPress.Result.handled
            }

            // Escキー → キャンセル
            .onKeyPress(.escape) {
                onCancel()
                return KeyPress.Result.handled
            }
    }

    // MARK: - Cursor Control

    private func moveCursorToEnd() {
        DispatchQueue.main.async {
            NSApp.keyWindow?
                .firstResponder?
                .tryToPerform(
                    #selector(NSTextView.moveToEndOfDocument(_:)),
                    with: nil
                )
        }
    }
}
