//
// Views/Rename/Apply/ApplyConfirmationView.swift
//
import SwiftUI

/// リネーム適用前の最終確認画面
///
/// - 変更内容（Diff）
/// - 件数サマリー
/// - 警告の有無
/// を確認し、実行可否を判断する
struct ApplyConfirmationView: View {

    let plans: [RenamePlan]

    let onApply: () -> Void
    let onCancel: () -> Void

    // MARK: - Derived

    private var changedPlans: [RenamePlan] {
        plans.filter { $0.originalName != $0.targetName }
    }

    private var warningPlans: [RenamePlan] {
        plans.filter { !$0.warnings.isEmpty }
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // MARK: Header
            HStack {
                Text("変更内容の確認")
                    .font(.title2)
                    .bold()

                Spacer()

                Button("キャンセル") {
                    onCancel()
                }
            }

            // MARK: Summary
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

            // MARK: List
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(changedPlans) { plan in
                        ApplyConfirmationRowView(plan: plan)
                    }
                }
                .padding(.vertical, 4)
            }

            Divider()

            // MARK: Actions
            HStack {
                Spacer()

                Button("実行する") {
                    onApply()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(changedPlans.isEmpty)
            }
        }
        .padding(24)
        .frame(minWidth: 640, minHeight: 520)
        .background(
            Color(nsColor: .windowBackgroundColor)
        )
    }

    // MARK: - Helpers

    private func summaryItem(
        title: String,
        value: String,
        isWarning: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.title3)
                .bold()
                .foregroundColor(isWarning ? .orange : .primary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(nsColor: .controlBackgroundColor))
        )
    }
}
