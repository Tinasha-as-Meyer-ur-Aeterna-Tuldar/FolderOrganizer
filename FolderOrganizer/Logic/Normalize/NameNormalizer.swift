// Logic/NameNormalizer.swift
//
// ファイル名・フォルダ名を正規化し、
// その結果と判断情報を Result として返す。
// Result は UI / Export / Undo / 学習用途の
// 単一の正規データ構造とする。
//

import Foundation

struct NameNormalizer {

    /// 正規化結果（プロジェクト全体の共通契約）
    struct Result {

        /// 最終的に使用する正規化後の名前
        let normalized: String

        /// ユーザーに伝えるべき警告文
        let warnings: [String]

        /// 適用されたルールID（将来の学習用）
        let appliedRules: [String]

        /// 警告が1つでもあるか（UI簡易判定用）
        var hasWarning: Bool {
            !warnings.isEmpty
        }
    }

    /// 正規化を実行する
    static func normalize(_ original: String) -> Result {

        var current = original
        var rules: [String] = []
        var warnings: [String] = []

        // 例：全角スペース → 半角
        if current.contains("　") {
            current = current.replacingOccurrences(of: "　", with: " ")
            rules.append("replace_fullwidth_space")
            warnings.append("全角スペースを半角に変換しました")
        }

        // 例：前後空白トリム
        let trimmed = current.trimmingCharacters(in: .whitespaces)
        if trimmed != current {
            current = trimmed
            rules.append("trim_whitespace")
        }

        // 将来ここにルール追加
        // if ... { warnings.append("〜〜の可能性があります") }

        return Result(
            normalized: current,
            warnings: warnings,
            appliedRules: rules
        )
    }
}
