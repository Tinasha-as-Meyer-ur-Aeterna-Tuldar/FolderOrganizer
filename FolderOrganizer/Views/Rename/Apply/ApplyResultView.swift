//
//  ApplyResultView.swift
//  FolderOrganizer
//

import SwiftUI

struct ApplyResultView: View {

    let results: [ApplyResult]
    let rollbackInfo: RollbackInfo?
    let onUndo: (RollbackInfo) -> Void
    let onClose: () -> Void

    // MARK: - Derived

    private var successCount: Int {
        results.filter { $0.isSuccess }.count
    }

    private var failureCount: Int {
        results.filter { !$0.isSuccess }.count
    }

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Apply 結果")
                .font(.headline)

            Text("成功: \(successCount) 件 / 失敗: \(failureCount) 件")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(results.indices, id: \.self) { index in
                        ApplyResultRowView(
                            result: results[index],   // ← 先
                            index: index              // ← 後
                        )
                    }
                }
            }

            Divider()

            HStack {
                if let rollbackInfo {
                    Button("Undo") {
                        onUndo(rollbackInfo)
                    }
                }

                Spacer()

                Button("閉じる") {
                    onClose()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(16)
        .frame(minWidth: 420)
    }
}
