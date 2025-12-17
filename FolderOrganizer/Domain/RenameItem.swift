// Models/RenameItem.swift
import Foundation

/// UIで編集しながら使う「1行ぶん」のリネーム作業データ
/// - original: 元の名前（フォルダ名）
/// - normalized: 正規化後の提案名（自動生成）
/// - edited: ユーザーが編集した名前（空なら未編集）
/// - flagged: 要注意フラグ（手動チェック用）
struct RenameItem: Identifiable, Hashable {

    // MARK: - Identity
    var id: UUID

    // MARK: - Core fields
    var original: String
    var normalized: String
    var edited: String
    var flagged: Bool

    // MARK: - Init
    init(
        id: UUID = UUID(),
        original: String,
        normalized: String,
        edited: String = "",
        flagged: Bool = false
    ) {
        self.id = id
        self.original = original
        self.normalized = normalized
        self.edited = edited
        self.flagged = flagged
    }

    // MARK: - Derived

    /// 現時点での「新しい名前」
    /// - edited が空なら normalized を採用
    var currentNewName: String {
        edited.isEmpty ? normalized : edited
    }

    /// ユーザーが編集して「提案名から変更されたか」
    var isModified: Bool {
        !edited.isEmpty && edited != normalized
    }

    /// 一覧表示に使う名前（RenamePreviewRowView 用）
    var displayNameForList: String {
        currentNewName
    }

    // MARK: - Subtitle heuristics

    var isSubtitle: Bool {
        TextClassifier.isSubtitle(currentNewName)
    }

    var isPotentialSubtitle: Bool {
        TextClassifier.isPotentialSubtitle(currentNewName)
    }

    // MARK: - Helpers

    /// 編集内容を破棄して「提案名」に戻す（ContentView の resetEditedName 対応）
    func resetEditedName() -> RenameItem {
        var copy = self
        copy.edited = ""
        return copy
    }
}
