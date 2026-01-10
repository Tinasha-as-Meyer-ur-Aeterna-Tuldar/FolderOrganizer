//
//  Theme/AppTheme.swift
//  FolderOrganizer
//
//  UI で使う色やスタイルを一箇所に集約
//

import SwiftUI

enum AppTheme {

    enum colors {

        // MARK: - Base

        /// 画面タイトル
        static let title: Color = .primary

        /// 画面背景
        static let background: Color = Color(nsColor: .windowBackgroundColor)

        /// メインボタンの tint
        static let primaryButton: Color = .accentColor

        /// サブテキスト
        static let secondaryText: Color = .secondary

        /// 警告系
        static let warning: Color = .orange

        /// 危険系
        static let danger: Color = .red

        static let accentColor = Color.accentColor
        static let cardBackground = Color(nsColor: .controlBackgroundColor)

        // MARK: - Space Marker（★ここが今回の本命）

        /// 半角スペース（通常・情報用）
        /// 見えるが主張しすぎない
        static let spaceHalf: Color = .teal.opacity(0.85)

        /// 全角スペース（注意）
        /// 「あ、これか」と一瞬で分かる
        static let spaceFull: Color = .orange

        /// 連続スペース（危険）
        /// ほぼ事故なので強め
        static let spaceMultiple: Color = .red.opacity(0.85)

        /// 改行・不可視文字（補助）
        static let invisible: Color = .secondary.opacity(0.6)
    }
}
