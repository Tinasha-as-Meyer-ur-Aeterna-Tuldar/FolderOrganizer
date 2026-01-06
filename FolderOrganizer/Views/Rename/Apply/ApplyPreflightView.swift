//
//  ApplyPreflightView.swift
//  FolderOrganizer
//

import SwiftUI

struct ApplyPreflightView: View {

    // MARK: - Inputs
    let document: RenameExportDocument
    let onApply: () -> Void
    let onCancel: () -> Void

    // MARK: - Computed
    private var hasBlockingErrors: Bool {
        document.issues.contains { $0.level == .error }
    }

    private var errorIssues: [RenameExportIssue] {
        document.issues.filter { $0.level == .error }
    }

    private var warningIssues: [RenameExportIssue] {
        document.issues.filter { $0.level == .warning }
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Apply 前確認")
                .font(.headline)

            // --- Summary ---
            VStack(alignment: .leading, spacing: 8) {
                Text("対象件数: \(document.items.count)")
                Text("警告: \(warningIssues.count)")
                    .foregroundColor(.orange)
                Text("エラー: \(errorIssues.count)")
                    .foregroundColor(hasBlockingErrors ? .red : .secondary)
            }

            Divider()

            // --- Issues ---
            if !document.issues.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(document.issues) { issue in
                            IssueRow(issue: issue)
                        }
                    }
                }
                .frame(maxHeight: 240)

                Divider()
            }

            // --- Actions ---
            HStack {
                Button("キャンセル", action: onCancel)

                Spacer()

                Button("Apply 実行") {
                    onApply()
                }
                .disabled(hasBlockingErrors)
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(minWidth: 420)
    }
}
