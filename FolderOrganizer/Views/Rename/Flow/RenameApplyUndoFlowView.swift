//
//  RenameApplyUndoFlowView.swift
//  FolderOrganizer
//

import SwiftUI

struct RenameApplyUndoFlowView: View {

    // MARK: - Input
    let results: [ApplyResult]
    let onCancel: () -> Void
    let onStartUndo: (RollbackInfo) -> Void
    let onFinish: () -> Void

    // MARK: - Derived

    /// 成功した ApplyResult から RollbackInfo を再構築
    private var rollbackInfo: RollbackInfo {
        let moves: [RollbackInfo.Move] = results.compactMap { result in
            switch result {
            case .success(_, _, let rollback):
                return rollback.moves
            case .failure:
                return nil
            }
        }
        .flatMap { $0 }

        return RollbackInfo(moves: moves)
    }

    /// Undo 可能な成功結果があるか
    private var hasAnySuccess: Bool {
        results.contains {
            if case .success = $0 { return true }
            return false
        }
    }

    // MARK: - View
    var body: some View {
        VStack(spacing: 16) {

            // Header
            HStack {
                Text("Apply 結果")
                    .font(.headline)
                Spacer()
                Button("閉じる", action: onFinish)
                    .keyboardShortcut(.defaultAction)
            }

            Divider()

            // Result list
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(results.indices, id: \.self) { index in
                        ApplyResultRowView(
                            result: results[index],
                            index: index
                        )
                    }
                }
            }

            Divider()

            // Actions
            HStack {
                Button("キャンセル", action: onCancel)

                Spacer()

                Button("Undo 実行") {
                    onStartUndo(rollbackInfo)
                }
                .disabled(!hasAnySuccess)
            }
        }
        .padding(20)
        .frame(minWidth: 420)
    }
}
