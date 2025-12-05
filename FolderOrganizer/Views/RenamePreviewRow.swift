//  Views/RenamePreviewRow.swift
import SwiftUI

struct RenamePreviewRow: View {
    let original: String
    let normalized: String
    let isOdd: Bool
    let isSelected: Bool
    @Binding var flagged: Bool

    // 行の背景色（サブタイトル > 要確認 > 交互）
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
        VStack(alignment: .leading, spacing: 6) {

            // 旧（インデント）
            HStack(alignment: .top, spacing: 4) {
                Text("旧:")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.colors.oldText)
                Text(original)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.colors.oldText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // 新（スペース赤表示）
            HStack(alignment: .top, spacing: 4) {
                Text("新:")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.colors.newText)
                DiffBuilder.highlightSpaces(in: normalized)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.colors.newText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // おかしい？
            Toggle(isOn: $flagged) {
                Text("おかしい？")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.colors.checkLabel)
            }
            .toggleStyle(.checkbox)
            .padding(.top, 4)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(backgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isSelected ? AppTheme.colors.selectedBorder : Color.clear,
                    lineWidth: 2
                )
        )
        // 🔵 ここでは「横幅指定」を一切しない
    }
}
