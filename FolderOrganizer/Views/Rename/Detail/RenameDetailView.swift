//
//  RenameDetailView.swift
//  FolderOrganizer
//
//  1 件の RenamePlan を詳細表示・確認する View
//

import SwiftUI

struct RenameDetailView: View {

    // MARK: - Input

    let plan: RenamePlan
    let onClose: () -> Void

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // ヘッダー
            HStack {
                Text("詳細")
                    .font(.headline)

                Spacer()

                Button("閉じる") {
                    onClose()
                }
            }

            Divider()

            // 元の名前
            VStack(alignment: .leading, spacing: 4) {
                Text("元の名前")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(plan.originalURL.lastPathComponent)
                    .font(.system(size: 13, design: .monospaced))
            }

            // 変更後の名前
            VStack(alignment: .leading, spacing: 4) {
                Text("変更後の名前")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(plan.destinationURL.lastPathComponent)
                    .font(.system(size: 13, design: .monospaced))
            }

            Divider()

            // フルパス情報
            VStack(alignment: .leading, spacing: 6) {
                Text("パス")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("元: \(plan.originalURL.path)")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)

                Text("先: \(plan.destinationURL.path)")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .frame(minWidth: 520, minHeight: 300)
    }
}
