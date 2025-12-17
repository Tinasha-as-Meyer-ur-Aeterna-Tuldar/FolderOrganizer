import SwiftUI

struct ApplyConfirmationRowView: View {

    let plan: RenamePlan

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(plan.originalName)
                .font(.body)

            Text("→ \(plan.targetParentFolder.lastPathComponent) / \(plan.targetName)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if !plan.warnings.isEmpty {
                ForEach(plan.warnings) { warning in
                    Label(
                        warning.message,
                        systemImage: warningIcon(for: warning)
                    )
                }
            }
        }
        .padding(.vertical, 6)
    }

    private func warningIcon(for warning: RenameWarning) -> String {
        switch warning {
        case .authorNotDetected:
            return "person.crop.circle.badge.questionmark"
        case .ambiguousSubtitle:
            return "questionmark.circle"
        case .duplicateNameExists:
            return "exclamationmark.triangle"
        }
    }

    private func warningColor(for warning: RenameWarning) -> Color {
        switch warning {
        case .authorNotDetected:
            return .red
        default:
            return .orange
        }
    }
}
