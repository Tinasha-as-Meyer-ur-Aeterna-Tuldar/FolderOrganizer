//
//  NameTokenizationService.swift
//  FolderOrganizer
//

import Foundation

protocol NameTokenizationService {

    /// 正規化済み文字列をトークンに分解
    func tokenize(_ normalizedName: String) -> NameTokens
}

final class DefaultNameTokenizationService: NameTokenizationService {

    func tokenize(_ normalizedName: String) -> NameTokens {

        // 🔧 C-3: まずは最小実装（後で強化）
        // TODO: [] や () 区切り、作者名抽出など

        return NameTokens(
            authorCandidates: [],
            titleCandidates: [normalizedName],
            rawSubstrings: []
        )
    }
}
