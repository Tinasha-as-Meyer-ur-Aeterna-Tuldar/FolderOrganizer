import SwiftUI

struct DryRunPreviewView: View {

    let plans: [RenamePlan]

    @StateObject private var decisionStore = UserDecisionStore()

    var body: some View {
        NavigationStack {
            List(plans) { plan in
                NavigationLink {
                    RenamePlanDetailView(
                        plan: plan,
                        decisionStore: decisionStore
                    )
                } label: {
                    RenamePlanRowView(plan: plan)
                }
            }
            .navigationTitle("Dry Run Preview")
        }
    }
}
