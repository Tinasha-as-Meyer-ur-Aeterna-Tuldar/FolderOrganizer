// Logic/TextClassifier.swift
import Foundation

/// ここは「将来の判定基準」を残す場所。
/// まずはビルド優先で簡易実装にしてあります。
enum TextClassifier {

    /// 例: 「サブタイトルっぽい」判定（確定）
    static func isSubtitle(_ text: String) -> Bool {
        // TODO: あなたの本来の基準に差し替え
        // 例: 先頭が "（" で始まる、または "：" が含まれる等
        return false
    }

    /// 例: 「サブタイトル候補」判定（要確認）
    static func isPotentialSubtitle(_ text: String) -> Bool {
        // TODO: あなたの本来の基準に差し替え
        return false
    }
}
