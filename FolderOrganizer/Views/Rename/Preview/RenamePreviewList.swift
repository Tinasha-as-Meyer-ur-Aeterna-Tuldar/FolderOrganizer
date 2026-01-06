//
//  RenamePreviewList.swift
//  FolderOrganizer
//

import SwiftUI

struct RenamePreviewList: View {

    // MARK: - Inputs
    let plans: [RenamePlan]
    let selectedID: UUID?
    let onSelect: (UUID) -> Void
    let onCommit: () -> Void

    // MARK: - Body
    var body: some View {
        List(plans) { plan in
            row(plan)
                .contentShape(Rectangle())
                .onTapGesture {
                    onSelect(plan.id)
                }
        }
        .onKeyPress(.return) {
            onCommit()
            return SwiftUI.KeyPress.Result.handled
        }
    }

    // MARK: - Row
    @ViewBuilder
    private func row(_ plan: RenamePlan) -> some View {

        let isChanged = plan.originalName != plan.normalizedName
        let isSelected = (plan.id == selectedID)

        HStack(spacing: 10) {

            Image(systemName: isChanged ? "pencil.circle.fill" : "circle")
                .foregroundStyle(isChanged ? .blue : .secondary)

            VStack(alignment: .leading, spacing: 2) {

                Text(plan.originalName)
                    .font(.system(size: 13, design: .monospaced))
                    .lineLimit(1)

                if isChanged {
                    Text("→ \(plan.normalizedName)")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
        .background(
            isSelected
            ? Color.accentColor.opacity(0.15)
            : Color.clear
        )
        .cornerRadius(6)
    }
}
