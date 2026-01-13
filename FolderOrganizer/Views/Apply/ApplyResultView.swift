// Views/Apply/ApplyResultView.swift
//
// Apply 実行後の結果表示画面（v0.2 UX 統合版）
// ・結果サマリ表示は ApplyResultList に委譲
// ・Footer（Undo / 閉じる）と Window 構造のみ担当
//

import SwiftUI

struct ApplyResultView: View {

    let results: [ApplyResult]
    let rollbackInfo: RollbackInfo?
    let onUndo: (RollbackInfo) -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // ===== 結果表示（中身は v0.2 UX）=====
            ApplyResultList(results: results)

            Divider()

            // ===== Footer =====
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
