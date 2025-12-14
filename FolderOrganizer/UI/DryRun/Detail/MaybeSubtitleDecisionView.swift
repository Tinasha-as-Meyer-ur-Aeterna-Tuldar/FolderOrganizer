import SwiftUI

struct MaybeSubtitleDecisionView: View {

    let plan: RenamePlan

    @ObservedObject var decisionStore: UserDecisionStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("不確定 subtitle の扱い")
                .font(.headline)

            Text(plan.maybeSubtitle ?? "")
                .font(.title3)
                .fontWeight(.semibold)

            Picker(
                "扱いを選択",
                selection: Binding(
                    get: {
                        decisionStore.decision(for: plan.originalURL)
                    },
                    set: { newValue in
                        decisionStore.setDecision(
                            newValue,
                            for: plan.originalURL
                        )
                    }
                )
            ) {
                Text("未決定").tag(UserSubtitleDecision.undecided)
                Text("subtitle として採用").tag(UserSubtitleDecision.confirmAsSubtitle)
                Text("無視する").tag(UserSubtitleDecision.ignore)
            }
            .pickerStyle(.segmented)

            Spacer()

            HStack {
                Spacer()
                Button("閉じる") {
                    dismiss()
                }
            }
        }
        .padding()
    }
}
