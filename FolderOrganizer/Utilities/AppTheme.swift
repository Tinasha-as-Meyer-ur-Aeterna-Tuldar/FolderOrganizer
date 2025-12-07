// Utilities/AppTheme.swift
import SwiftUI

enum AppTheme {
    struct colors {

        // 画面全体
        static let background = Color(red: 0.96, green: 0.98, blue: 1.0)

        // 通常行（交互背景）
        static let cardBackground   = Color.white
        static let rowAltBackground = Color(red: 0.93, green: 0.96, blue: 1.0)

        // サブタイトル確定（〜XXX〜 がきちんと判定された行）
        static let subtitleBackground = Color(red: 0.84, green: 0.92, blue: 1.0)

        // サブタイトル要確認（怪しい行：一覧）
        static let potentialSubtitleBackground =
            Color(red: 1.00, green: 0.94, blue: 0.78)

        // サブタイトル要確認（詳細ポップアップ用・少し濃い）
        static let potentialSubtitleStrong =
            Color(red: 1.00, green: 0.90, blue: 0.55)

        // オーバーレイ
        static let dimmedOverlay = Color.black.opacity(0.25)

        // テキスト
        static let title      = Color(red: 0.18, green: 0.27, blue: 0.69)
        static let oldText    = Color.black
        static let newText    = Color(red: 0.10, green: 0.28, blue: 0.75)
        static let checkLabel = Color.gray

        // 半角スペースの表示色
        static let spaceMarker = Color.red

        // ボタン・選択枠
        static let primaryButton  = Color(red: 0.19, green: 0.35, blue: 0.86)
        static let selectedBorder = Color(red: 0.19, green: 0.35, blue: 0.86)
    }
}
