import SwiftUI

struct MaybeSubtitleDecisionView: View {

    let plan: RenamePlan
    @ObservedObject var decisionStore: UserDecisionStore

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        VStack(spacing: 20) {

            Text("この文字列を Subtitle として扱いますか？")
                .font(.headline)

            if let maybe = plan.maybeSubtitle {
                Text(maybe)
                    .font(.title3)
                    .padding()
            }

            VStack(spacing: 12) {

                Button {
                    decisionStore.setDecision(
                        .confirmAsSubtitle,
                        for: plan.originalURL
                    )
                    dismiss()
                } label: {
                    Text("Subtitle として採用")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    decisionStore.setDecision(
                        .ignore,
                        for: plan.originalURL
                    )
                    dismiss()
                } label: {
                    Text("無視する")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .onChange(
            of: decisionStore.decision(for: plan.originalURL)
        ) { (_: UserSubtitleDecision) in
            // DecisionStore 側で再 DryRun が走るので何もしない
        }
    }
}
