// Views/RenamePreviewRow.swift
import SwiftUI

struct RenamePreviewRow: View {
    let original: String
    let normalized: String
    let isOdd: Bool
    let isSelected: Bool
    @Binding var flagged: Bool

    // 背景色（サブタイトル > 要確認 > 交互）
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
            HStack(alignment: .top, spacing: 4) {
                Text("旧:")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.colors.oldText)

                Text(original)
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.colors.oldText)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // 新
            HStack(alignment: .top, spacing: 4) {
                Text("新:")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.colors.newText)

                DiffBuilder.highlightSpaces(in: normalized)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.colors.newText)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // おかしい？
            Toggle(isOn: $flagged) {
                Text("おかしい？")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.colors.checkLabel)
            }
            .toggleStyle(.checkbox)
            .padding(.top, 2)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        // 🔴 ここがポイント：行全体を親の幅いっぱいに広げる
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .cornerRadius(8)
        // 選択中だけ枠線
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? AppTheme.colors.selectedBorder : Color.clear,
                        lineWidth: 2)
        )
        // クリック判定を行全体に
        .contentShape(Rectangle())
    }
}
