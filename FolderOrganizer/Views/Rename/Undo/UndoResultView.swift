//
//  UndoResultView.swift
//  FolderOrganizer
//

import SwiftUI

struct UndoResultView: View {

    let undoResults: [UndoResult]
    let rollbackInfo: RollbackInfo
    let onClose: () -> Void

    // MARK: - Derived

    /// 成功した Undo の index 一覧
    private var successIndexes: [Int] {
        undoResults.enumerated().compactMap { index, result in
            if case .success = result {
                return index
            }
            return nil
        }
    }

    /// 失敗した Undo（index + error）
    private var failureErrors: [(Int, Error)] {
        undoResults.enumerated().compactMap { index, result in
            if case .failure(let error) = result {
                return (index, error)
            }
            return nil
        }
    }

    private var successCount: Int { successIndexes.count }
    private var failureCount: Int { failureErrors.count }

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text("Undo 結果")
                .font(.headline)

            Text("成功: \(successCount) 件 / 失敗: \(failureCount) 件")
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            VStack(alignment: .leading, spacing: 8) {

                // 成功行（RollbackInfo から Move を引く）
                ForEach(successIndexes, id: \.self) { index in
                    UndoResultRowView(
                        index: index,
                        move: rollbackInfo.moves[index]
                    )
                }

                // 失敗行
                ForEach(failureErrors, id: \.0) { index, error in
                    UndoResultErrorRowView(
                        index: index,
                        error: error
                    )
                }
            }

            Divider()

            HStack {
                Spacer()
                Button("閉じる", action: onClose)
                    .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
    }
}
