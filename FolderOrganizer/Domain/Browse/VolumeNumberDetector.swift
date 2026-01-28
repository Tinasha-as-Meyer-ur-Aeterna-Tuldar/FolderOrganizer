// FolderOrganizer/Domain/Browse/VolumeNumberDetector.swift
//
// 巻数表現の検出ユーティリティ
// - アラビア数字
// - 漢数字（壱 / 十 / 十一 など）
// - 第◯巻 / 巻 / vol / v
//

import Foundation

enum VolumeNumberDetector {

    // MARK: - Public API

    /// 名前に「巻数表現」が含まれているか
    static func containsVolumeNumber(in text: String) -> Bool {
        let normalized = text.lowercased()

        // 明示トークン
        if containsExplicitVolumeToken(normalized) {
            return true
        }

        // アラビア数字
        if containsArabicNumber(normalized) {
            return true
        }

        // 漢数字（単体 or 複合）
        if isPureKanjiNumber(text) {
            return true
        }

        return false
    }

    /// 「壱」「十」「十一」「弐拾」など、漢数字のみで構成されているか
    static func isPureKanjiNumber(_ text: String) -> Bool {
        guard !text.isEmpty else { return false }
        return text.allSatisfy { kanjiSet.contains($0) }
    }

    // MARK: - Internals

    private static let kanjiSet: Set<Character> = [
        "一","二","三","四","五","六","七","八","九","十",
        "壱","弐","参","肆","伍","陸","漆","捌","玖","拾"
    ]

    private static func containsArabicNumber(_ text: String) -> Bool {
        text.rangeOfCharacter(from: .decimalDigits) != nil
    }

    private static func containsExplicitVolumeToken(_ text: String) -> Bool {
        return text.contains("第")
            || text.contains("巻")
            || text.contains("vol")
            || text.contains("v")
    }
}
