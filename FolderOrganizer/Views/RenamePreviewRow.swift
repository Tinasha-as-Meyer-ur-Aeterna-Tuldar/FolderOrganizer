// Views/RenamePreviewRow.swift
import SwiftUI

struct RenamePreviewRow: View {
    let original: String
    let normalized: String
    let isOdd: Bool
    let isSelected: Bool
    @Binding var flagged: Bool

    private var backgroundColor: Color {
        if TextClassifier.isSubtitle(normalized) {
            return AppTheme.colors.subtitleBackground
        }
        if TextClassifier.isPotentialSubtitle(normalized) {
            return AppTheme.colors.potentialSubtitleBackground
        }
        return isOdd ? AppTheme.colors.cardBackground
                     : AppTheme.colors.rowAltBackground
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            // 旧
            HStack(alignment: .top, spacing: 6) {
                Text("旧:")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.colors.oldText)
                Text(original)
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.colors.oldText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // 新
            HStack(alignment: .top, spacing: 6) {
                Text("新:")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.colors.newText)
                DiffBuilder.highlightSpaces(in: normalized)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.colors.newText)
            }

            Toggle("おかしい？", isOn: $flagged)
                .font(.system(size: 12))
                .toggleStyle(.checkbox)
                .padding(.top, 2)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        // 🔴 行全体を左右いっぱいに
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? AppTheme.colors.selectedBorder : .clear, lineWidth: 2)
        )
        .contentShape(Rectangle())
    }
}
