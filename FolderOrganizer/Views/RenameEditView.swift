//  Views/RenameEditView.swift
import SwiftUI

struct RenameEditView: View {

    @Binding var editText: String          // 旧のコピーを編集する
    let onCommit: (String) -> Void        // Enter で呼ばれる
    let onCancel: () -> Void              // Esc / 枠外クリックで呼ばれる

    var body: some View {
        ZStack {
            // 背景の暗幕（クリックで閉じる）
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    onCancel()
                }

            VStack(alignment: .leading, spacing: 12) {

                Text("修正（Enter で反映 / Esc でキャンセル）")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.blue)

                // 上：色付きスペースマーカー表示エリア
                ScrollView(.horizontal, showsIndicators: true) {
                    DiffBuilder.highlightSpacesEditor(in: editText)
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                }
                .frame(minHeight: 44, maxHeight: 60)          // 少し余裕を持たせる
                .background(Color.white)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )

                // 下：実際の編集エリア
                MonospaceTextEditor(
                    text: $editText,
                    onCommit: { onCommit(editText) },
                    onCancel: { onCancel() }
                )
                .frame(minHeight: 160, maxHeight: 240)

                // 改行は即座に削除して 1 行に保つ
                .onChange(of: editText) { newValue in
                    if newValue.contains("\n") {
                        editText = newValue.replacingOccurrences(of: "\n", with: "")
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(24)
            .frame(width: 760, height: 360)      // ざっくり 800x600 内に収まるサイズ
            .background(Color.white)
            .cornerRadius(16)
        }
        // ここでは Enter / Esc を扱わない（TextEditor 内の onKeyPress に任せる）
    }
}
