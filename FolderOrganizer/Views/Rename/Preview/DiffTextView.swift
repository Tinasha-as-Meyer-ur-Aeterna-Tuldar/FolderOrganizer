//
//  Views/Rename/Preview/DiffTextView.swift
//
//  Myers Diff 表示（STEP 3-7）
//  ・Diff 用カラーを AppTheme に集約
//  ・View は「意味 → 色」を Theme に委譲
//

import SwiftUI

struct DiffTextView: View {

    let original: String
    let normalized: String
    let showSpaceMarkers: Bool

    private var diffResult: (original: [DiffToken], normalized: [DiffToken]) {
        DiffBuilder.build(
            original: original,
            normalized: normalized
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {

            render(tokens: diffResult.original)
                .foregroundStyle(AppTheme.colors.secondaryText)

            render(tokens: diffResult.normalized)
                .foregroundStyle(AppTheme.colors.primaryText)
        }
        .font(.system(size: 15, design: .monospaced))
    }

    // MARK: - Rendering

    private func render(tokens: [DiffToken]) -> Text {
        tokens.reduce(Text("")) { result, token in
            let displayChar = visibleCharacter(token.character)
            let color = colorFor(token)

            return result + Text(displayChar).foregroundColor(color)
        }
    }

    // MARK: - Color Resolver

    private func colorFor(_ token: DiffToken) -> Color? {
        switch token.operation {
        case .delete:
            return AppTheme.colors.diffDelete

        case .insert:
            return AppTheme.colors.diffInsert

        case .replace:
            return AppTheme.colors.diffReplace

        case .equal:
            if isSpace(token.character) {
                return AppTheme.colors.diffSpace
            } else {
                return nil
            }
        }
    }

    // MARK: - Space Handling

    private func isSpace(_ char: String) -> Bool {
        char == " " || char == "　"
    }

    private func visibleCharacter(_ char: String) -> String {
        guard showSpaceMarkers else { return char }

        switch char {
        case " ":
            return "␣"
        case "　":
            return "□"   // 全角スペース（区別不要なら "␣" に統一してもOK）
        default:
            return char
        }
    }
}
