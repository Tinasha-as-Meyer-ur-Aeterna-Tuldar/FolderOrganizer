// Views/Rename/Preview/DryRunPreviewView.swift
//
// DryRun（実行前プレビュー）画面
//

import SwiftUI
import Combine

struct DryRunPreviewView: View {

    // MARK: - Dependencies

    let engine: RenamePlanEngine
    @ObservedObject var decisionStore: UserDecisionStore

    // MARK: - Inputs

    let rootURL: URL

    // MARK: - State

    @State private var plans: [RenamePlan] = []

    // MARK: - View

    var body: some View {
        ApplyConfirmationView(
            plans: plans,
            onApply: {
                print("Apply tapped")
            },
            onCancel: {
                print("Cancel tapped")
            }
        )
        .onAppear {
            rebuildPlans()
        }
        .onReceive(decisionStore.decisionsPublisher) { _ in
            rebuildPlans()
        }
    }

    // MARK: - Private

    private func rebuildPlans() {
        plans = engine.buildPlans(from: rootURL)
    }
}
