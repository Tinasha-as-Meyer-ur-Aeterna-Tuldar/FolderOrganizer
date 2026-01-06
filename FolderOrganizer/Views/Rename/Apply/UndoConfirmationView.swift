//
//  UndoConfirmationView.swift
//  FolderOrganizer
//

import SwiftUI

struct UndoConfirmationView: View {

    // MARK: - Input
    let results: [ApplyResult]
    let isExecuting: Bool
    let onExecute: () -> Void
    let onCancel: () -> Void

    // MARK: - Derived
    private var rollbackMoves: [RollbackInfo.Move] {
        results.compactMap { result in
            if case .success(_, _, let rollback) = result {
                return rollback.moves
            }
            return nil
        }
        .flatMap { $0 }
    }

    private var descriptionText: String {
        "以下のリネーム結果を元に戻します。"
    }

    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Undo の確認")
                .font(.headline)

            Text(descriptionText)
                .font(.caption)
                .foregroundStyle(.secondary)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(rollbackMoves.enumerated()), id: \.offset) { index, move in
                        UndoResultRowView(
                            index: index,
                            move: move
                        )
                    }
                }
            }
            .frame(maxHeight: 240)

            Divider()

            if isExecuting {
                ProgressView("Undo 実行中…")
                    .progressViewStyle(.linear)
            }

            HStack {
                Button("キャンセル", action: onCancel)
                    .disabled(isExecuting)

                Spacer()

                Button("Undo 実行", action: onExecute)
                    .keyboardShortcut(.defaultAction)
                    .disabled(isExecuting)
            }
        }
        .padding(20)
    }
}
