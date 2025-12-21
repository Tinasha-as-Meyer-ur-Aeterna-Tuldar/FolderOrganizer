//
// Views/Common/SpaceMarkerTextView.swift
//
import SwiftUI

/// スペース可視化対応テキスト表示View
///
/// - 半角スペース: ␣ (U+2423)
/// - 全角スペース: □ (U+25A1)
/// - ON/OFFでレイアウト・文字サイズが変わらない
struct SpaceMarkerTextView: View {

    private let text: String
    private let showSpaceMarkers: Bool
    private let font: Font

    init(
        _ text: String,
        showSpaceMarkers: Bool,
        font: Font = .system(
            size: 14,
            weight: .semibold,
            design: .monospaced
        )
    ) {
        self.text = text
        self.showSpaceMarkers = showSpaceMarkers
        self.font = font
    }

    var body: some View {
        Text(renderedText)
            .font(font)
    }

    /// 表示用 AttributedString を生成
    private var renderedText: AttributedString {
        guard showSpaceMarkers else {
            return AttributedString(text)
        }

        var result = AttributedString()

        for character in text {
            switch character {
            case " ":
                var marked = AttributedString("␣")
                marked.foregroundColor = .secondary
                result.append(marked)

            case "　":
                var marked = AttributedString("□")
                marked.foregroundColor = .secondary
                result.append(marked)

            default:
                result.append(
                    AttributedString(String(character))
                )
            }
        }

        return result
    }
}
