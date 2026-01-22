//
// Views/Common/ExecutionResultRowView.swift
// Apply / Undo 共通の結果行表示
//
import SwiftUI

struct ExecutionResultRowView: View {
    let success: Bool
    let title: String
    let errorMessage: String?

    /// 成功行だけ Undo 開始できるようにする（必要なければ nil を渡せる）
    let onUndo: (() -> Void)?

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: success ? "checkmark.circle.fill" : "xmark.octagon.fill")
                .foregroundStyle(success ? .green : .red)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(.body, design: .monospaced))
                    .lineLimit(2)

                if let errorMessage, !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }
            }

            Spacer()

            if success, let onUndo {
                Button("Undo") {
                    onUndo()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
    }
}
