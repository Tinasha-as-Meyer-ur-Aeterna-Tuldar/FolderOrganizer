//
// Views/Common/ExecutionProgressView.swift
// Apply / Undo 共通の進捗表示ビュー
//
import SwiftUI

/// 実行中（Apply / Undo）の進捗表示用 View
struct ExecutionProgressView: View {

    let title: String
    let message: String
    let progress: Double
    let progressText: String
    let onCancel: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {

            Text(title)
                .font(.title2)
                .bold()

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)

            ProgressView(value: progress)
                .progressViewStyle(.linear)

            Text(progressText)
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            if let onCancel {
                Divider()

                HStack {
                    Spacer()
                    Button("中止") {
                        onCancel()
                    }
                }
            }
        }
        .padding(20)
        .frame(minWidth: 420, minHeight: 220)
    }
}
