// Logic/TextClassifier.swift
import Foundation

/// フォルダ名（正規化済み）の「構造」を軽く判定するユーティリティ
struct TextClassifier {

    /// 「これはサブタイトルっぽい（かなり確度高い）」とみなす条件
    static func isSubtitle(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        // 短めで記号を含むものを優先して「サブタイトル」扱い
        if trimmed.count <= 32 {
            if trimmed.contains(" – ") || trimmed.contains("―") || trimmed.contains("―") {
                return true
            }
        }

        // 括弧のみ／括弧＋短いフレーズ
        if trimmed.hasPrefix("「"), trimmed.hasSuffix("」") {
            return true
        }

        // 数字＋話数・巻数
        if trimmed.contains("話") || trimmed.contains("巻") {
            return true
        }

        return false
    }

    /// 「サブタイトルの可能性はあるが、要確認（薄いハイライト）」レベル
    static func isPotentialSubtitle(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        // 少し長め＋区切り記号を含む場合
        if trimmed.count <= 60 {
            if trimmed.contains(" – ")
                || trimmed.contains(" - ")
                || trimmed.contains("：")
                || trimmed.contains(":")
            {
                return true
            }
        }

        // かっこ始まり
        if trimmed.hasPrefix("(") || trimmed.hasSuffix(")") {
            return true
        }

        return false
    }
}
