import SwiftUI
import AppKit

enum AppTheme {
    struct colors {

        // MARK: - 全体背景
        static let background = Color(NSColor.windowBackgroundColor)

        // MARK: - 行背景（通常 / 交互）
        static let cardBackground = Color(NSColor.textBackgroundColor)
        static let rowAltBackground = Color(NSColor.underPageBackgroundColor)

        // マーカーを邪魔しない薄い区切り線
        static let rowSeparator = Color(NSColor.separatorColor)

        // MARK: - サブタイトル行
        // 信頼度の高い判定（自動OK）
        static let subtitleBackground =
            Color(NSColor.systemBlue.withAlphaComponent(0.15))

        // 要チェック（候補）
        static let potentialSubtitleBackground =
            Color(NSColor.systemOrange.withAlphaComponent(0.18))

        // ニュートラルな背景
        static let neutralBackground = cardBackground

        // MARK: - テキスト色
        static let titleText = Color(NSColor.labelColor)
        static let oldText = Color(NSColor.secondaryLabelColor)
        static let newText = Color(NSColor.systemBlue)  // ここは強めの Blue にする

        // チェックラベルなど
        static let checkLabel = Color(NSColor.tertiaryLabelColor)

        // MARK: - スペースマーカー
        static let spaceMarkerHalf = Color(NSColor.systemRed)
        static let spaceMarkerFull = Color(NSColor.systemBlue)

        // MARK: - 行選択枠（青）
        static let selectedBorder = Color(NSColor.controlAccentColor)
    }
}
