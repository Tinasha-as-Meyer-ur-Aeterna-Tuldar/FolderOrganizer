// Logic/NameNormalizer.swift
import Foundation

/// フォルダ名の正規化を担当する最小実装
/// ※ 今回は「壊さない」ことを最優先し、最低限のルールのみ適用する
enum NameNormalizer {

    /// 最小限の正規化を行う
    /// - Parameters:
    ///   - input: 元のフォルダ名
    /// - Returns: 正規化結果（警告含む）
    static func normalize(_ input: String) -> NormalizationResult {

        var result = input
        var warnings: [RenameWarning] = []

        // ------------------------------------
        // ① 全角スペース → 半角スペース
        // ------------------------------------
        if result.contains("　") {
            result = result.replacingOccurrences(of: "　", with: " ")
            warnings.append(.fullWidthSpaceReplaced)
        }

        // ------------------------------------
        // ② 連続する半角スペースを1つに圧縮
        // ------------------------------------
        let collapsed = collapseSpaces(result)
        if collapsed != result {
            result = collapsed
            warnings.append(.multipleSpacesCollapsed)
        }

        // ------------------------------------
        // 結果を返す
        // ------------------------------------
        return NormalizationResult(
            original: input,
            normalizedName: result,
            warnings: warnings
        )
    }

    /// 連続する半角スペースを1つにまとめる
    private static func collapseSpaces(_ text: String) -> String {
        var output = ""
        var previousWasSpace = false

        for ch in text {
            if ch == " " {
                if !previousWasSpace {
                    output.append(ch)
                }
                previousWasSpace = true
            } else {
                output.append(ch)
                previousWasSpace = false
            }
        }

        return output
    }
}
