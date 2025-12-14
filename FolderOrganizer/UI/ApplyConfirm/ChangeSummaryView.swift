import SwiftUI

struct ChangeSummaryView: View {

    let summary: RenameChangeSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("変更サマリー")
                .font(.headline)

            summaryRow("総件数", summary.total)
            summaryRow("移動あり", summary.moveCount)
            summaryRow("名前変更のみ", summary.renameOnlyCount)
            summaryRow("変更なし", summary.noChangeCount)

            Divider()

            summaryRow("警告あり", summary.warningCount, color: .orange)
            summaryRow("実行不可", summary.blockingCount, color: .red)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(8)
    }

    private func summaryRow(
        _ title: String,
        _ value: Int,
        color: Color = .primary
    ) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(value)")
                .foregroundColor(color)
                .fontWeight(.semibold)
        }
    }
}
