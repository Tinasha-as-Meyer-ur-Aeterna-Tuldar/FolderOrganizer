//
//  ChangeSummaryView.swift
//  FolderOrganizer
//

import SwiftUI

/// Apply 前に表示する変更サマリー View
struct ChangeSummaryView: View {

    let summary: RenameExportSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("変更サマリー")
                .font(.headline)

            // --- 基本情報 ---
            summaryRow("フラグ付き", summary.flaggedCount)
            summaryRow("手動修正あり", summary.userEditedCount)

            Divider()

            // --- 警告 / エラー ---
            summaryRow("警告あり", summary.warningCount, color: .orange)
            summaryRow("エラーあり", summary.errorCount, color: .red)

            if summary.hasBlockingErrors {
                Text("⚠️ エラーがあるため Apply できません")
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(8)
    }

    // MARK: - Row

    private func summaryRow(
        _ title: String,
        _ value: Int,
        color: Color = .primary
    ) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value)")
                .foregroundColor(color)
                .monospacedDigit()
        }
    }
}
