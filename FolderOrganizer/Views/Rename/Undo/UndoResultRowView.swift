//
//  UndoResultRowView.swift
//

import SwiftUI

struct UndoResultRowView: View {

    let index: Int
    let move: RollbackInfo.Move

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.uturn.backward.circle.fill")
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 2) {
                Text("Undo 成功 \(index + 1)")
                Text(move.to.lastPathComponent)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
