//
//  DryRunPreviewView.swift
//  FolderOrganizer
//

import SwiftUI
import Combine

/// DryRun（実行前プレビュー）画面
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
                print("Apply tapped")
            },
            onCancel: {
                print("Cancel tapped")
            }
        )
        .onAppear {
            rebuildPlans()
        }
        .onReceive(decisionStore.decisionsPublisher) {
            rebuildPlans()
        }
    }

    // MARK: - Private
    private func rebuildPlans() {
        plans = itemURLs.map {
            engine.generatePlan(for: $0)
        }
    }
}
