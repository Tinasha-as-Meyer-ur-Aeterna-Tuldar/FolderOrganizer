//
//  UndoResultErrorRowView.swift
//  FolderOrganizer
//

import SwiftUI

struct UndoResultErrorRowView: View {

    let index: Int
    let error: Error

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.red)

            VStack(alignment: .leading, spacing: 2) {
                Text("Undo 失敗 \(index + 1)")
                    .font(.body)

                Text(error.localizedDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
