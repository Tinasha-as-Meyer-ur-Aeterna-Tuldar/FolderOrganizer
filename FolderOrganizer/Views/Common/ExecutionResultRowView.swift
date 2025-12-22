//
// Views/Common/ExecutionResultRowView.swift
// Apply / Undo 共通の結果行表示
//
import SwiftUI

/// 実行結果（Apply / Undo）の 1 行表示用 View
///
/// - success: 成功 / 失敗
/// - title: 表示する名前（例: originalName）
/// — errorMessage: 失敗時のエラーメッセージ（nil 可）
struct ExecutionResultRowView: View {

    let success: Bool
    let title: String
    let errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            HStack(spacing: 8) {
                Image(systemName: success
                      ? "checkmark.circle.fill"
                      : "xmark.octagon.fill")
                    .foregroundColor(success ? .green : .orange)

                Text(title)
                    .font(
                        .system(
                            size: 13,
                            weight: .semibold,
                            design: .monospaced
                        )
                    )
                    .lineLimit(1)
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
    }
}
