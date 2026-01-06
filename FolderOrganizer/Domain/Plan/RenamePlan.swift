//
//  RenamePlan.swift
//  FolderOrganizer
//

import Foundation

/// 1件のリネーム計画（プレビュー／Apply／Undo の中心モデル）
///
/// 注意:
/// - normalizeResult は NameNormalizer の内部結果で、Equatable/Hashable でない可能性がある。
/// - そのため RenamePlan の Equatable/Hashable は「id のみ」で成立させる（安定・安全）。
struct RenamePlan: Identifiable, Hashable {

    // MARK: - Identity

    let id: UUID

    // MARK: - Paths

    /// 変更前（元の場所）
    let originalURL: URL

    /// 変更後（適用先）
    let destinationURL: URL

    // MARK: - Display

    /// UI表示用（元名）
    let originalName: String

    /// UI表示用（正規化後名＝新しいファイル名）
    let normalizedName: String

    // MARK: - Analysis

    /// 検出された役割（作者/サークル等）
    let roles: [DetectedRole]

    /// コンテキスト（親フォルダ等の情報）
    let context: ContextInfo

    /// 正規化の結果（warnings 含む）
    ///
    /// ✅ 重要：外から生成しない。必ず NameNormalizer に任せる。
    let normalizeResult: NameNormalizer.Result

    // MARK: - Init

    init(
        id: UUID = UUID(),
        originalURL: URL,
        destinationURL: URL,
        originalName: String,
        normalizedName: String,
        roles: [DetectedRole],
        context: ContextInfo
    ) {
        self.id = id
        self.originalURL = originalURL
        self.destinationURL = destinationURL
        self.originalName = originalName
        self.normalizedName = normalizedName
        self.roles = roles
        self.context = context

        // ✅ 正規化は必ず NameNormalizer に任せる（Result を外から new しない）
        self.normalizeResult = NameNormalizer.normalize(originalName)
    }

    // MARK: - Equatable / Hashable

    /// id のみで同一性を判定する（normalizeResult は比較対象にしない）
    static func == (lhs: RenamePlan, rhs: RenamePlan) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
