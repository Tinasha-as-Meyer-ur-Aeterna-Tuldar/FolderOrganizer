// Logic/NameNormalizer.swift
import Foundation

/// 最小の正規化（必要に応じて後で置き換え）
enum NameNormalizer {
    static func normalize(_ name: String) -> String {
        // 例：全角スペース→半角スペース、連続スペースを1つに
        let half = name.replacingOccurrences(of: "　", with: " ")
        let collapsed = half.replacingOccurrences(of: #" {2,}"#, with: " ", options: .regularExpression)
        return collapsed.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
