// Utilities/DiffBuilder.swift
import SwiftUI

struct DiffBuilder {

    /// 半角スペースを「␣」（赤・太字）で可視化して返す
    static func highlightSpaces(in text: String) -> Text {
        var result = Text("")

        for ch in text {
            if ch == " " {
                result = result +
                    Text("␣")
                        .bold()
                        .foregroundColor(AppTheme.colors.spaceMarker)
            } else {
                result = result + Text(String(ch))
            }
        }
        return result
    }
}
