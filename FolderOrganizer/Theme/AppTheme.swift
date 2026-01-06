//
//  Theme/AppTheme.swift
//  FolderOrganizer
//
//  UI で使う色やスタイルを一箇所に集約
//

import SwiftUI

enum AppTheme {

    enum colors {
        /// 画面タイトル
        static let title: Color = .primary

        /// 画面背景
        static let background: Color = Color(nsColor: .windowBackgroundColor)

        /// メインボタンの tint
        static let primaryButton: Color = .accentColor

        /// 警告系
        static let warning: Color = .orange

        /// 危険系
        static let danger: Color = .red

        /// サブテキスト
        static let secondaryText: Color = .secondary

        static let accentColor = Color.accentColor
        static let cardBackground = Color(nsColor: .controlBackgroundColor)
    }
}
