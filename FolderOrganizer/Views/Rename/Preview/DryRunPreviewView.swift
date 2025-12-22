//
// Views/Rename/Preview/DryRunPreviewView.swift
//
import SwiftUI
import Combine

/// DryRun（実行前プレビュー）画面
/// - RenamePlan を生成し
/// - ApplyConfirmationView に渡す責任を持つ
struct DryRunPreviewView: View {

    // MARK: - Dependencies
    let engine: RenamePlanEngine
    @ObservedObject var decisionStore: UserDecisionStore

    // MARK: - Inputs
    let itemURLs: [URL]

    // MARK: - State
    @State private var plans: [RenamePlan] = []

    // MARK: - View
    var body: some View {
        ApplyConfirmationView(
            plans: plans,
            onApply: {
                // 👉 ここは次のステップで ApplyExecutionView へ
                print("Apply tapped")
            },
            onCancel: {
                // 👉 親 View が dismiss する想定
                print("Cancel tapped")
            }
        )
        .onAppear {
            rebuildPlans()
        }
        // サブタイトル判定変更
        .onReceive(decisionStore.$subtitleDecisions) { _ in
            rebuildPlans()
        }
        // Author 判定変更
        .onReceive(decisionStore.$authorDecisions) { _ in
            rebuildPlans()
        }
    }

    // MARK: - Build plans
    private func rebuildPlans() {
        plans = itemURLs.map { url in
            engine.generatePlan(for: url)
        }
    }
}
