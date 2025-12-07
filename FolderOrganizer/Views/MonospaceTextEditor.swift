import SwiftUI

struct MonospaceTextEditor: View {
    @Binding var text: String
    var onCommit: (() -> Void)? = nil
    var onCancel: (() -> Void)? = nil

    @FocusState private var isFocused: Bool

    var body: some View {
        TextEditor(text: $text)
            .font(.system(size: 16, design: .monospaced))
            .foregroundColor(.black)
            .padding(6)
            .background(Color.white)
            .cornerRadius(6)
            .focused($isFocused)
            .onAppear {
                DispatchQueue.main.async {
                    isFocused = true          // フォーカスを当てる
                    moveCursorToEnd()
                }
            }
            .onSubmit {
                onCommit?()
            }
            .onKeyPress(.escape) { _ in
                onCancel?()
                return .handled      // ★これが必要！
            }
            .onKeyPress(.return) { _ in
                onCommit?()
                return .handled
            }
    }

    private func moveCursorToEnd() {
        // macOS TextEditor のカーソル移動
        NSApp.keyWindow?.firstResponder?
            .tryToPerform(#selector(NSTextView.moveToEndOfDocument(_:)), with: nil)
    }
}
