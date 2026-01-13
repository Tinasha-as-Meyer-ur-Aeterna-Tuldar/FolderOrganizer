// Domain/Export/RenamePlanLog.swift
//
// JSON Export 用の RenamePlan ログ（DTO）
// - URL / 既存モデルをそのまま Codable にしない
// - 将来 Import / Replay / 学習ログに繋げるために「最小で必要な情報」を保存
//

import Foundation

struct RenamePlanLog: Codable, Hashable, Identifiable {

    // MARK: - Identity

    let id: UUID

    // MARK: - Paths

    /// Apply 前のパス
    let originalPath: String

    /// Apply 後のパス（予定）
    let targetPath: String

    // MARK: - Names

    let originalName: String
    let normalizedName: String

    // MARK: - Flags

    let isChanged: Bool

    /// v0.2-1 時点では「誰が変えたか（auto/manual）」の厳密な追跡はまだ行わない
    /// 将来 v0.2-2（学習ログ）で拡張する前提で、今は "unspecified" 固定
    let source: String

    /// 旧互換（warnings）を JSON にも残す（UI で説明可能・将来の学習材料にもなる）
    let warnings: [String]

    // MARK: - Init

    init(
        id: UUID,
        originalPath: String,
        targetPath: String,
        originalName: String,
        normalizedName: String,
        isChanged: Bool,
        source: String = "unspecified",
        warnings: [String]
    ) {
        self.id = id
        self.originalPath = originalPath
        self.targetPath = targetPath
        self.originalName = originalName
        self.normalizedName = normalizedName
        self.isChanged = isChanged
        self.source = source
        self.warnings = warnings
    }
}
