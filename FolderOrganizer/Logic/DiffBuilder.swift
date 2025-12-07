// Logic/DiffBuilder.swift
import SwiftUI

struct DiffBuilder {

    // MARK: - 一覧・詳細画面用（「新:」の行など）
    //  - 半角スペース: ␣（赤）
    //  - 全角スペース: □（緑）
    static func highlightSpaces(in text: String) -> Text {
        var result = Text("")

        for ch in text {
            if ch == " " {
                // 半角スペース
                let part = Text("␣")
                    .foregroundColor(AppTheme.colors.spaceMarkerHalf)
                result = result + part
            } else if ch == "　" {
                // 全角スペース
                let part = Text("□")
                    .foregroundColor(AppTheme.colors.spaceMarkerFull)
                result = result + part
            } else {
                // 通常文字（新タイトル用の青ではなく、呼び出し側で色を指定）
                let part = Text(String(ch))
                result = result + part
            }
        }
        return result
    }

    // MARK: - 編集画面用スペース可視化（上の細い欄）
    //  - ここも同じ記号だが、文字色は明示的に黒にしておく
    static func highlightSpacesEditor(in text: String) -> Text {
        var result = Text("")

        for ch in text {
            if ch == " " {
                let part = Text("␣")
                    .foregroundColor(AppTheme.colors.spaceMarkerHalf)
                result = result + part
            } else if ch == "　" {
                let part = Text("□")
                    .foregroundColor(AppTheme.colors.spaceMarkerFull)
                result = result + part
            } else {
                let part = Text(String(ch))
                    .foregroundColor(.black)
                result = result + part
            }
        }
        return result
    }
}
