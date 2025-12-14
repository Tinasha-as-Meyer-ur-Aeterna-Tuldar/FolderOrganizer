import SwiftUI

struct DryRunPreviewView: View {

    let itemURLs: [URL]
    @ObservedObject var decisionStore: UserDecisionStore

    @State private var plans: [RenamePlan] = []
    @State private var showApplyConfirm = false

    private let engine = RenamePlanEngine()

    var body: some View {
        List(plans) { plan in
            NavigationLink {
                RenamePlanDetailView(plan: plan, decisionStore: decisionStore)
            } label: {
                RenamePlanRowView(plan: plan)
            }
        }
        .navigationTitle("Dry Run Preview")
        .toolbar {
            ToolbarItem {
                Button("Apply 確認へ") {
                    showApplyConfirm = true
                }
                .disabled(plans.isEmpty)
            }
        }
        .navigationDestination(isPresented: $showApplyConfirm) {
            ApplyConfirmationView(plans: plans)
        }
        .onAppear {
            rebuildPlans()
        }
        .onReceive(decisionStore.$subtitleDecisions) { _ in
            rebuildPlans()
        }
        .onReceive(decisionStore.$authorDecisions) { _ in
            rebuildPlans()
        }
    }

    // MARK: - Build plans with decisions

    private func rebuildPlans() {

        plans = itemURLs.map { url in

            // subtitle decision
            let subtitleDecision = decisionStore.decision(for: url)

            var plan = engine.generatePlan(
                for: url,
                userDecision: subtitleDecision
            )

            // 🔑 author 不明をユーザー了承で解除
            if decisionStore.authorDecision(for: url) == .allowWithoutAuthor {
                plan = plan.allowingWithoutAuthor()
            }

            return plan
        }
    }
}
