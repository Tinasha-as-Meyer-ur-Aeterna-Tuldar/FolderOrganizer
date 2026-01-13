//
//  ApplyConfirmationView.swift
//  FolderOrganizer
//

import SwiftUI

/// Apply 実行前の最終確認画面
struct ApplyConfirmationView: View {

    // MARK: - Inputs
    let plans: [RenamePlan]
    let onApply: () -> Void
    let onCancel: () -> Void

    // MARK: - Derived

    /// 実際に名前が変わるプランのみ
    private var changedPlans: [RenamePlan] {
        plans.filter {
            $0.originalName != $0.destinationURL.lastPathComponent
        }
    }

    /// Warning を含むプラン
    private var warningPlans: [RenamePlan] {
        plans.filter {
            !$0.normalizeResult.warnings.isEmpty
        }
    }

    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Summary
            HStack(spacing: 16) {
                summaryItem(
                    title: "変更",
                    value: "\(changedPlans.count)"
                )

                summaryItem(
                    title: "警告",
                    value: "\(warningPlans.count)",
                    isWarning: !warningPlans.isEmpty
                )
            }

            Divider()

            // Plan List
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(changedPlans) { plan in
                        ApplyConfirmationRowView(plan: plan)
                        Divider()
                    }
                }
            }

            Divider()

            // Actions
            HStack {
                Button("キャンセル") {
                    onCancel()
                }

                Spacer()

                Button("Apply 実行") {
                    onApply()
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .frame(minWidth: 520, minHeight: 420)
    }

    // MARK: - Summary Item
    @ViewBuilder
    private func summaryItem(
        title: String,
        value: String,
        isWarning: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.headline)
                .foregroundStyle(isWarning ? .orange : .primary)
        }
    }
}
