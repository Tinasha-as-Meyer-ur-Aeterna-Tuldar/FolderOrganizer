//
//  ApplyResultRowView.swift
//  FolderOrganizer
//

import SwiftUI

struct ApplyResultRowView: View {

    let result: ApplyResult
    let index: Int

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            Image(systemName: iconName)
                .foregroundStyle(iconColor)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {

                Text("Item \(index + 1)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                switch result {

                case .success(
                    plan: let plan,
                    destinationURL: let destinationURL,
                    rollback: _
                ):
                    Text(plan.originalName)
                        .font(.system(size: 12, design: .monospaced))

                    Text("→ \(destinationURL.lastPathComponent)")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)

                case .failure(let error):
                    Text("Apply 失敗")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.red)

                    Text(error.localizedDescription)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
    }

    // MARK: - Icon

    private var iconName: String {
        switch result {
        case .success:
            return "checkmark.circle.fill"
        case .failure:
            return "xmark.octagon.fill"
        }
    }

    private var iconColor: Color {
        switch result {
        case .success:
            return .green
        case .failure:
            return .red
        }
    }
}
