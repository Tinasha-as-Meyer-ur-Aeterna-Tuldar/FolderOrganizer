//  Logic/TextClassifier.swift
import Foundation

struct TextClassifier {

    /// 〜/～/~ を すべて「〜」に揃える
    private static func normalizeTilde(_ text: String) -> String {
        text
            .replacingOccurrences(of: "～", with: "〜")
            .replacingOccurrences(of: "~", with: "〜")
    }

    /// 確定サブタイトル：末尾が「〜XXXX〜」の形になっているもの
    static func isSubtitle(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        let s = normalizeTilde(trimmed)

        // 「〜」の位置を全部拾う
        let indices = s.indices.filter { s[$0] == "〜" }
        guard indices.count >= 2,
              let first = indices.first,
              let last  = indices.last,
              first != last else {
            return false
        }

        // 最後の「〜」は末尾であること
        guard s.index(after: last) == s.endIndex else {
            return false
        }

        // 中身が 2 文字以上
        let innerCount = s.distance(from: s.index(after: first), to: last)
        return innerCount >= 2
    }

    /// 要確認サブタイトル：
    /// - 上の isSubtitle ではない
    /// - 「〜」が 1 回だけ出てくる か
    /// - 末尾付近に「ー」がある
    static func isPotentialSubtitle(_ text: String) -> Bool {
        if isSubtitle(text) { return false }

        let trimmed = text.trimmingCharacters(in: .whitespaces)
        let s = normalizeTilde(trimmed)

        let tildeCount = s.filter { $0 == "〜" }.count

        let hasLongVowelNearEnd: Bool = {
            guard let last = s.lastIndex(of: "ー") else { return false }
            // 末尾から 5 文字以内に「ー」がある
            let distance = s.distance(from: last, to: s.endIndex)
            return distance <= 6
        }()

        if tildeCount == 1 { return true }
        if hasLongVowelNearEnd { return true }

        return false
    }
}
