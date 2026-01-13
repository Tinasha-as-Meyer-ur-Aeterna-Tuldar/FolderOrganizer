// Views/Apply/ApplyResultRow.swift
//
// ApplyResult 1 件分の表示
// - 状態に応じたアイコンと色を表示
// - 文言は Domain 側ではなく View 側で解釈
//

import SwiftUI

struct ApplyResultRow: View {

    let result: ApplyResult

    var body: some View {
        HStack(alignment: .top, spacing: 8) {

            statusIcon
                .frame(width: 16)

            VStack(alignment: .leading, spacing: 2) {
                Text(result.plan.normalizedName)
                    .font(.body)

                statusText
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    // MARK: - Status

    private var statusIcon: some View {
        switch result.status {
        case .success:
            return Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)

        case .skipped:
            return Image(systemName: "minus.circle.fill")
                .foregroundColor(.gray)

        case .failure:
            return Image(systemName: "xmark.octagon.fill")
                .foregroundColor(.red)
        }
    }

    private var statusText: some View {
        switch result.status {
        case .success:
            return Text("変更されました")

        case .skipped(let reason):
            return Text(reason)

        case .failure(let error):
            return Text(error.localizedDescription)
        }
    }
}
