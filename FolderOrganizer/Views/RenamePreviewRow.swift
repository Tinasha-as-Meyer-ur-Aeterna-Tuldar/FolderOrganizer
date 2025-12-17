// Views/RenamePreviewRow.swift
import SwiftUI

struct RenamePreviewRow: View {

    let original: String
    let displayName: String
    let isOdd: Bool
    let isSelected: Bool
    let isModified: Bool
    let isSubtitle: Bool
    let isPotentialSubtitle: Bool
    @Binding var flagged: Bool

    var body: some View {
        HStack(spacing: 12) {

            // 左：Original（薄く）
            Text(original)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 右：提案/編集結果
            Text(displayName)
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

            // バッジ類
            HStack(spacing: 6) {
                if isModified {
                    Text("MOD")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(AppTheme.colors.modifiedBadge.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                if isSubtitle {
                    Text("SUB")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(AppTheme.colors.subtitleBadge.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else if isPotentialSubtitle {
                    Text("MAYBE")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(AppTheme.colors.maybeBadge.opacity(0.25))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }

            Toggle("", isOn: $flagged)
                .toggleStyle(.checkbox)
                .labelsHidden()
                .frame(width: 24)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.accentColor.opacity(0.8) : Color.clear, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var backgroundColor: Color {
        if isSelected { return Color.accentColor.opacity(0.12) }
        return isOdd ? AppTheme.colors.rowOdd : AppTheme.colors.rowEven
    }
}
