// Logic/NameNormalizer.swift
import Foundation

/// フォルダ名を正規化するための処理群
struct NameNormalizer {

    /// Public API — これを呼べばすべての処理がかかる
    static func normalize(_ name: String) -> String {
        var result = name

        // 1. カテゴリ（[DLsite] 等）を先に除去
        result = removeCategoryPrefix(result)

        // 2. [サークル名 (作者名)] → [作者名]
        result = fixAuthorBracket(in: result)

        // 3. タグ削除（[全年齢], [DL版] など）
        result = removeTags(in: result)

        // 4. サブタイトル整形（" - " → " – " 等）
        result = fixSubtitle(in: result)

        // 5. 余分な空白を整える
        result = cleanSpaces(result)

        return result
    }

    // MARK: - 1. カテゴリ削除（先頭の [XXXX] を落とす）
    private static func removeCategoryPrefix(_ name: String) -> String {
        // 例: "[DLsite] [たつわの里 (タツワイプ)] 作品名" → "[たつわの里 (タツワイプ)] 作品名"
        let pattern = #"^\[[^\]]+\]\s*"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return name }

        let range = NSRange(name.startIndex..<name.endIndex, in: name)
        return regex.stringByReplacingMatches(in: name, range: range, withTemplate: "")
    }

    // MARK: - 2. [サークル名 (作者名)] → [作者名]
    ///
    /// 例:
    ///   "[たつわの里 (タツワイプ)] テリル崩壊..." → "[タツワイプ] テリル崩壊..."
    private static func fixAuthorBracket(in name: String) -> String {
        let pattern = #"\[([^()\[\]]+)\s*\(([^()\[\]]+)\)\]"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else { return name }

        let nsRange = NSRange(name.startIndex..<name.endIndex, in: name)

        guard let match = regex.firstMatch(in: name, range: nsRange),
              match.numberOfRanges == 3
        else {
            return name
        }

        // 作者名（第2キャプチャ）
        let authorRangeNS = match.range(at: 2)
        guard let authorRange = Range(authorRangeNS, in: name) else { return name }
        let author = String(name[authorRange])

        // マッチ全体
        let fullRangeNS = match.range(at: 0)
        guard let fullRange = Range(fullRangeNS, in: name) else { return name }

        // マッチの後ろ（作品タイトルなど）
        let afterStart = fullRange.upperBound
        let after = afterStart < name.endIndex ? String(name[afterStart...]) : ""

        if after.isEmpty {
            return "[\(author)]"
        } else {
            // 例: "[タツワイプ] テリル崩壊..."
            return "[\(author)] \(after)"
        }
    }

    // MARK: - 3. タグ削除（[全年齢], [DL版], [日本語版] など汎用）
    private static func removeTags(in name: String) -> String {
        let pattern = #"\[[^\]]*\]"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else { return name }

        let nsRange = NSRange(name.startIndex..<name.endIndex, in: name)
        let cleaned = regex.stringByReplacingMatches(in: name, range: nsRange, withTemplate: "")

        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - 4. サブタイトル整形
    private static func fixSubtitle(in name: String) -> String {
        // 例: "タイトル - サブタイトル" → "タイトル – サブタイトル"
        var s = name
        s = s.replacingOccurrences(of: " - ", with: " – ")
        return s
    }

    // MARK: - 5. スペース整形
    private static func cleanSpaces(_ name: String) -> String {
        var s = name

        // 全角スペース → 半角
        s = s.replacingOccurrences(of: "　", with: " ")

        // 多重スペースの整理
        while s.contains("  ") {
            s = s.replacingOccurrences(of: "  ", with: " ")
        }

        // 前後空白を削除
        s = s.trimmingCharacters(in: .whitespacesAndNewlines)

        return s
    }
}
