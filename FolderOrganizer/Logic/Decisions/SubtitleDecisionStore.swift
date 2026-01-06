//
//  SubtitleDecisionStore.swift
//  FolderOrganizer
//
//  maybeSubtitle（曖昧な Subtitle 候補）に対する
//  ユーザー判断を保持する Store
//

import Foundation
import Combine

/// Subtitle として扱うかどうかのユーザー判断を保持
final class SubtitleDecisionStore: ObservableObject {

    // MARK: - Stored Decisions
    /// key: originalURL
    /// value: true = Subtitle として扱う / false = 無視する
    @Published
    private(set) var decisions: [URL: Bool] = [:]

    // MARK: - Init
    init(decisions: [URL: Bool] = [:]) {
        self.decisions = decisions
    }

    // MARK: - Public API

    /// ユーザー判断を保存
    func setSubtitleDecision(
        confirmAsSubtitle: Bool,
        for originalURL: URL
    ) {
        decisions[originalURL] = confirmAsSubtitle
    }

    /// 判断済みかどうか
    func hasDecision(for originalURL: URL) -> Bool {
        decisions[originalURL] != nil
    }

    /// Subtitle として確定したか
    func isConfirmedSubtitle(for originalURL: URL) -> Bool {
        decisions[originalURL] == true
    }

    /// 無視すると判断されたか
    func isIgnored(for originalURL: URL) -> Bool {
        decisions[originalURL] == false
    }

    /// 判断をクリア（Undo / 再判定用）
    func clearDecision(for originalURL: URL) {
        decisions.removeValue(forKey: originalURL)
    }

    /// 全判断をリセット
    func resetAll() {
        decisions.removeAll()
    }
}
