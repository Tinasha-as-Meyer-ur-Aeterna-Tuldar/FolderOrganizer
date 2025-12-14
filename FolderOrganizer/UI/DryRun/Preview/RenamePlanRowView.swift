import SwiftUI

struct RenamePlanRowView: View {

    let plan: RenamePlan

    // 🔽 Diff 表示設定
    @AppStorage(DiffSettings.showDiffKey)
    private var showDiff: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text("Before")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(plan.originalName)
                .font(.body)

            Text("After")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 4)

            if showDiff {
                DiffTextView(
                    segments: TextDiff.diff(
                        before: plan.originalName,
                        after: plan.targetName
                    )
                )
            } else {
                Text(plan.targetName)
                    .font(.body)
                    .fontWeight(.semibold)
            }

            if !plan.warnings.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("\(plan.warnings.count) warning")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 6)
    }
}
