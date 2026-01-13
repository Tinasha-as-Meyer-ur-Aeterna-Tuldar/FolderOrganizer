//
//  AppTheme.swift
//
//  アプリ全体のテーマ定義
//  ・Diff / SpaceMarker 用カラーを集約
//

import SwiftUI

enum AppTheme {

    enum colors {

        // MARK: - Text

        static let primaryText = Color.primary
        static let secondaryText = Color.secondary

        // MARK: - Diff Colors（STEP 3）

        static let diffDelete  = Color.red
        static let diffInsert  = Color.green
        static let diffReplace = Color.orange.opacity(0.85)
        static let diffSpace   = Color.accentColor.opacity(0.55)

        // MARK: - SpaceMarker Colors（共通）

        /// 半角スペース
        static let spaceHalf = Color.accentColor.opacity(0.45)

        /// 全角スペース
        static let spaceFull = Color.accentColor.opacity(0.65)

        /// 連続スペース（複数）
        static let spaceMultiple = Color.accentColor.opacity(0.55)
    }
}
