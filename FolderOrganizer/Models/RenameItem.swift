// Models/RenameItem.swift
import Foundation

/// 1行ぶんのリネームデータ
struct RenameItem: Identifiable, Hashable {
    let id = UUID()

    /// 元名（ファイルシステム由来）
    let original: String

    /// 自動正規化（提案）
    var normalized: String

    /// ユーザー編集後（最終名）
    var edited: String

    /// 要確認フラグ
    var flagged: Bool = false

    init(original: String, normalized: String, flagged: Bool = false) {
        self.original = original
        self.normalized = normalized
        self.edited = normalized
        self.flagged = flagged
    }

    /// 編集済みかどうか
    var isModified: Bool {
        edited != normalized
    }

    /// 一覧表示用の名前
    /// - 未編集 → 提案（normalized）
    /// - 編集済み → 編集後（edited）
    var displayNameForList: String {
        isModified ? edited : normalized
    }

    /// 詳細表示用（常に現在の最終名）
    var currentNewName: String {
        edited
    }

    /// サブタイトル判定（現在の表示名基準）
    var isSubtitle: Bool {
        TextClassifier.isSubtitle(displayNameForList)
    }

    /// サブタイトル候補判定
    var isPotentialSubtitle: Bool {
        TextClassifier.isPotentialSubtitle(displayNameForList)
    }
}
