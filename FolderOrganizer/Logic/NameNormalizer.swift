import Foundation

struct NameNormalizer {

    static func normalize(_ name: String) -> NormalizationResult {
        let original = name

        // 全角スペース → 半角
        var working = original.replacingOccurrences(of: "　", with: " ")

        // 連続スペースを1つに
        while working.contains("  ") {
            working = working.replacingOccurrences(of: "  ", with: " ")
        }

        // 前後トリム
        working = working.trimmingCharacters(in: .whitespacesAndNewlines)

        let tokens = working.split(separator: " ").map(String.init)

        var warnings: [RenameWarning] = []
        if working != original {
        }

        return NormalizationResult(
            originalName: original,
            normalizedName: working,
            tokens: tokens,
            warnings: warnings
        )
    }
}
