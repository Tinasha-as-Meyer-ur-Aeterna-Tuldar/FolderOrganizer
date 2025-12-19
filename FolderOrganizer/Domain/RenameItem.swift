// Models/RenameItem.swift
import Foundation

/// UIで編集しながら使う「1行ぶん」のリネーム作業データ
///
/// - original: 元の名前（フォルダ名）
/// - normalized: 正規化後の提案名（自動生成）
/// - edited: ユーザーが編集した最終候補（未編集なら normalized を入れておく）
/// - flagged: 要確認フラグ（手動チェック用）
struct RenameItem: Identifiable, Hashable {
    // MARK: - Identity
    var id: UUID

    // MARK: - Core fields
    var original: String
    var normalized: String
    var edited: String
    var flagged: Bool

    // MARK: - Init

    /// 推奨：基本はこちらを使う。
    /// edited は「空」ではなく、最初から normalized を入れておく（＝編集欄に表示される）
    init(
        id: UUID = UUID(),
        original: String,
        normalized: String,
        edited: String? = nil,
        flagged: Bool = false
    ) {
        self.id = id
        self.original = original
        self.normalized = normalized

        // ここがBの本体：編集欄が空にならないようにする
        // - edited が nil / "" の場合は normalized を採用
        let e = (edited ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.edited = e.isEmpty ? normalized : edited!

        self.flagged = flagged
    }

    // MARK: - Convenience

    /// 一覧で表示する「現在の名前」
    /// （基本は edited を表示。万一空なら normalized にフォールバック）
    var displayNameForList: String {
        let e = edited.trimmingCharacters(in: .whitespacesAndNewlines)
        return e.isEmpty ? normalized : e
    }

    /// 編集内容が「提案と同じか？」（差分表示やMODバッジ判定に使う）
    var isModified: Bool {
        displayNameForList != normalized
    }

    /// 「提案に戻す」ボタン用（昔の呼び出し互換）
    func resetEditedName() -> RenameItem {
        var copy = self
        copy.edited = normalized
        return copy
    }

    /// 明示的に編集値を更新したい場合
    func withEdited(_ newValue: String) -> RenameItem {
        var copy = self
        copy.edited = newValue
        return copy
    }

    // MARK: - Subtitle helpers（既存設計を尊重）

    /// 自動でサブタイトルと判定されたもの
    var isSubtitle: Bool {
        TextClassifier.isSubtitle(displayNameForList)
    }

    /// サブタイトルの可能性あり（要チェック）
    var isPotentialSubtitle: Bool {
        TextClassifier.isPotentialSubtitle(displayNameForList)
    }
}
