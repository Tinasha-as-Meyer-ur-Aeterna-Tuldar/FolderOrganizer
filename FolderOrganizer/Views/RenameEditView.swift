import SwiftUI

struct RenameEditView: View {

    @Binding var editText: String
    let onCommit: (String) -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            // 背景の暗幕
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 14) {

                Text("修正（Enter で反映 / Esc でキャンセル）")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.blue)

                // ===========================
                // ↑ スペースマーカー表示
                // 折り返し可能 & 高さ固定
                // ===========================
                ScrollView {
                    DiffBuilder.highlightSpaces(in: editText)
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundColor(.black)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                }
                .frame(height: 80) // ← ここで高さ確保
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )

                // ===========================
                // ↓ 実際の編集エリア
                // ===========================
                MonospaceTextEditor(
                    text: $editText,
                    onCommit: { onCommit(editText) },
                    onCancel: onCancel
                )
                .frame(minHeight: 180, maxHeight: 260)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )

                Spacer(minLength: 0)
            }
            .padding(28)
            .frame(width: 760, height: 420)
            .background(Color.white)
            .cornerRadius(18)
        }
        // Enter / Esc をフック
        .onKeyDown { event in
            switch event.keyCode {
            case 36, 76: onCommit(editText)  // Enter
            case 53:     onCancel()          // Esc
            default: break
            }
        }
    }
}
