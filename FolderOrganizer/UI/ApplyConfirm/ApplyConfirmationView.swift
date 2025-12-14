import SwiftUI

struct ApplyConfirmationView: View {

    let plans: [RenamePlan]

    // MARK: - State

    @State private var confirmed = false
    @State private var showExecution = false
    @State private var showFinalAlert = false

    // MARK: - Summary

    private var summary: RenameChangeSummary {
        RenameChangeSummary.build(from: plans)
    }

    private var hasBlockingError: Bool {
        summary.blockingCount > 0
    }

    private var hasAnyChange: Bool {
        summary.moveCount + summary.renameOnlyCount > 0
    }

    var body: some View {
        NavigationStack {

            VStack(spacing: 0) {

                // MARK: - Plan List

                List(plans) { plan in
                    ApplyConfirmationRowView(plan: plan)
                }

                Divider()

                // MARK: - Diff Toggle

                DiffToggleView()
                    .padding(.horizontal)
                    .padding(.top, 8)

                // MARK: - Summary

                ChangeSummaryView(summary: summary)
                    .padding(.horizontal)
                    .padding(.top, 8)

                Divider()
                    .padding(.top, 8)

                // MARK: - Guard Area

                VStack(alignment: .leading, spacing: 12) {

                    if hasBlockingError {
                        Label(
                            "実行不可の項目があります。Apply はできません。",
                            systemImage: "xmark.octagon.fill"
                        )
                        .foregroundColor(.red)
                    } else if !hasAnyChange {
                        Label(
                            "変更される項目がありません。",
                            systemImage: "info.circle.fill"
                        )
                        .foregroundColor(.secondary)
                    } else {
                        Toggle(
                            "内容を確認し、実行結果を理解しました",
                            isOn: $confirmed
                        )
                    }

                    Button {
                        showFinalAlert = true
                    } label: {
                        Text("一括 Apply を実行")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(
                        hasBlockingError ||
                        !hasAnyChange ||
                        !confirmed
                    )
                }
                .padding()
            }
            .navigationTitle("Apply Confirmation")
            .alert("一括 Apply の最終確認", isPresented: $showFinalAlert) {

                Button("実行する", role: .destructive) {
                    showExecution = true
                }

                Button("キャンセル", role: .cancel) {}

            } message: {
                Text("""
                以下の内容で一括 Apply を実行します。

                ・移動あり: \(summary.moveCount) 件
                ・名前変更のみ: \(summary.renameOnlyCount) 件
                ・変更なし: \(summary.noChangeCount) 件

                この操作は Undo で元に戻せます。
                """)
            }
            .navigationDestination(isPresented: $showExecution) {
                ApplyExecutionView(plans: plans)
            }
        }
    }
}
