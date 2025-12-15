// NameNormalizer.swift
import Foundation

struct NameNormalizer {

    static func normalize(_ name: String) -> NormalizationResult {

        let original = name
        var working = name

        // -----------------------------------------
        // 1. Unicode 正規化（濁点分離 → 結合）
        // 例: デ → デ
        // -----------------------------------------
        working = working.precomposedStringWithCanonicalMapping

        // -----------------------------------------
        // 2. 全角スペース → 半角
        // -----------------------------------------
        working = working.replacingOccurrences(of: "　", with: " ")

        // -----------------------------------------
        // 3. 連続セミコロン整理 (;; → ;)
        // -----------------------------------------
        while working.contains(";;") {
            working = working.replacingOccurrences(of: ";;", with: ";")
        }

        // -----------------------------------------
        // 4. 全角括弧を半角に統一
        // -----------------------------------------
        let bracketMap: [String: String] = [
            "（": "(",
            "）": ")",
            "［": "[",
            "］": "]",
            "【": "[",
            "】": "]"
        ]

        for (from, to) in bracketMap {
            working = working.replacingOccurrences(of: from, with: to)
        }

        // -----------------------------------------
        // 5. 連続スペースを1つに
        // -----------------------------------------
        while working.contains("  ") {
            working = working.replacingOccurrences(of: "  ", with: " ")
        }

        // -----------------------------------------
        // 6. 前後の空白トリム
        // -----------------------------------------
        working = working.trimmingCharacters(in: .whitespacesAndNewlines)

        // -----------------------------------------
        // tokens（将来用）
        // -----------------------------------------
        let tokens = working.split(separator: " ").map(String.init)

        // -----------------------------------------
        // 今回はまだ解析しない項目
        // -----------------------------------------
        let title = working
        let subtitle: String? = nil
        let maybeSubtitle: String? = nil
        let author: String? = nil

        // -----------------------------------------
        // warnings（設計どおり返す）
        // -----------------------------------------
        var warnings: [RenameWarning] = []

        // 例：正規化で変化がなかった場合の警告（将来用）
        if working == original {
            // 今は出さない（ノイズになるため）
            // warnings.append(.noNormalizationApplied)
        }

        return NormalizationResult(
            originalName: original,
            normalizedName: working,
            tokens: tokens,
            author: author,
            title: title,
            subtitle: subtitle,
            maybeSubtitle: maybeSubtitle,
            warnings: warnings
        )
    }
}
