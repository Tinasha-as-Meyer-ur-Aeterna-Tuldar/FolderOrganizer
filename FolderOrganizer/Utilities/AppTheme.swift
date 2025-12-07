// Utilities/AppTheme.swift
import SwiftUI

struct AppTheme {
    struct colors {

        // MARK: - 背景

        /// アプリ全体の背景色（ウィンドウ）
        static let windowBackground = Color(red: 0.96, green: 0.97, blue: 1.00)

        /// コンテンツ背景
        static let background = Color(red: 0.97, green: 0.98, blue: 1.00)

        /// 一覧のカード（奇数行）
        static let cardBackground = Color(red: 1.00, green: 0.97, blue: 0.92)

        /// 一覧のカード（偶数行）
        static let rowAltBackground = Color(red: 1.00, green: 0.95, blue: 0.86)

        /// 「副題」確定行の背景
        static let subtitleBackground = Color(red: 1.00, green: 1.00, blue: 0.90)

        /// 「副題かも？」候補行の背景
        static let potentialSubtitleBackground = Color(red: 1.00, green: 0.97, blue: 0.90)

        // MARK: - 文字色

        /// タイトル「FolderOrganizer」
        static let titleText = Color(red: 0.15, green: 0.25, blue: 0.65)

        /// 旧タイトルの文字色
        static let oldText = Color.brown

        /// 新タイトル（自動生成）の文字色
        static let newText = Color.blue

        // MARK: - ボタン / 枠線

        /// メインボタン（フォルダ読み込み / 前へ / 次へ）
        static let primaryButton = Color.blue

        /// 選択中カードの枠線
        static let selectedBorder = Color.blue

        /// チェックボックスのラベルなど
        static let checkLabel = Color.gray

        // MARK: - スペースマーカー

        /// 半角スペース用のマーカー色（␣）
        static let spaceMarkerHalf = Color.red

        /// 全角スペース用のマーカー色（□）
        static let spaceMarkerFull = Color.green
    }
}
