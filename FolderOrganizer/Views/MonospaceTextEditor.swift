// Views/MonospaceTextEditor.swift
import SwiftUI

struct MonospaceTextEditor: View {
    @Binding var text: String
    var onCommit: () -> Void
    var onCancel: () -> Void

    var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 16, design: .monospaced))
            .foregroundColor(.black)                          // 文字は黒
            .padding(6)
            .background(Color.white)                          // 背景は白で固定
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .onAppear {
                moveCursorToEnd()
            }
            // Enter → 保存
        // Enter → 保存
        .onKeyPress(.return) {
            onCommit()
            return .handled
        }
        // Esc → キャンセル
        .onKeyPress(.escape) {
            onCancel()
            return .handled
        }
    }

    private func moveCursorToEnd() {
        // macOS の NSTextView にカーソル移動命令
        DispatchQueue.main.async {
            NSApp.keyWindow?.firstResponder?
                .tryToPerform(#selector(NSTextView.moveToEndOfDocument(_:)), with: nil)
        }
    }
}
