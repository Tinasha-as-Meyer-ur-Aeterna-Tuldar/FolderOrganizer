// Views/DryRunPreviewView.swift
import SwiftUI
import Combine

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
        ApplyConfirmationView(plans: plans)
            .onAppear {
                rebuildPlans()
            }
            // Subtitle decision changed
            .onReceive(decisionStore.$subtitleDecisions) { _ in
                rebuildPlans()
            }
            // Author decision changed
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
