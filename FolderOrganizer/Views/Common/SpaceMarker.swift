//
//  Views/Common/SpaceMarker.swift
//
//  不可視文字（スペース等）を可視化するためのマーカー
//  ・半角 / 全角 / 連続スペースを区別
//  ・色は AppTheme に完全依存
//

import SwiftUI

enum SpaceMarker {

    /// 半角スペース
    static func half() -> Text {
        Text("␣")
            .foregroundStyle(AppTheme.colors.spaceHalf)
    }

    /// 全角スペース
    static func full() -> Text {
        Text("□")
            .foregroundStyle(AppTheme.colors.spaceFull)
    }

    /// 連続スペース（2個以上）
    static func multiple(count: Int) -> Text {
        let symbols = String(repeating: "␣", count: count)
        return Text(symbols)
            .foregroundStyle(AppTheme.colors.spaceMultiple)
    }
}
