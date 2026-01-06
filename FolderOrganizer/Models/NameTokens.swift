//
//  NameTokens.swift
//  FolderOrganizer
//

import Foundation

/// 名前を解析した結果のトークン集合
struct NameTokens: Hashable {

    /// 作者候補
    let authorCandidates: [String]

    /// タイトル候補
    let titleCandidates: [String]

    /// 生の部分文字列（将来の拡張用）
    let rawSubstrings: [String]

    // MARK: - Heuristics

    var hasAuthor: Bool {
        !authorCandidates.isEmpty
    }

    var hasExplicitSubtitle: Bool {
        titleCandidates.count >= 2
    }

    /// 「副題っぽい」候補（例：後半）
    var subtitleCandidate: String? {
        guard titleCandidates.count >= 2 else { return nil }
        return titleCandidates.dropFirst().joined(separator: " ")
    }
}
