//
//  IssueRow.swift
//  FolderOrganizer
//

import SwiftUI

struct IssueRow: View {

    let issue: RenameExportIssue

    var body: some View {
        HStack(alignment: .top, spacing: 8) {

            Image(systemName: iconName)
                .foregroundStyle(iconColor)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 2) {
                Text(issue.title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(issue.message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    // MARK: - Icon

    private var iconName: String {
        switch issue.level {
        case .info:
            return "info.circle"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .error:
            return "xmark.octagon.fill"
        }
    }

    private var iconColor: Color {
        switch issue.level {
        case .info:
            return .secondary
        case .warning:
            return .orange
        case .error:
            return .red
        }
    }
}
