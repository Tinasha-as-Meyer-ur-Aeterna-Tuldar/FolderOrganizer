// Domain/Export/ApplyResultLog.swift
//
// JSON Export 用の ApplyResult ログ（DTO）
// - Error など Codable 不可能なものは「文字列」として落とす
// - 表示用文言は凍結しない（UI 文言は将来変わるため）
//

import Foundation

struct ApplyResultLog: Codable, Hashable, Identifiable {

    // MARK: - Identity

    /// JSON 側での一意性（planID だけだと複数回 Apply で衝突し得るので別 ID を持つ）
    let id: UUID

    /// 元の plan の ID（結果と計画を紐づけるキー）
    let planID: UUID

    // MARK: - Paths

    let originalPath: String
    let targetPath: String

    // MARK: - Status

    enum Status: String, Codable {
        case success
        case skipped
        case failure
    }

    let status: Status

    /// skipped reason 等（必要なら表示に使えるが、UI 文言自体は別で管理する前提）
    let detail: String?

    /// failure のときの簡易エラー内容（LocalizedDescription 相当）
    let errorDescription: String?

    // MARK: - Init

    init(
        id: UUID = UUID(),
        planID: UUID,
        originalPath: String,
        targetPath: String,
        status: Status,
        detail: String?,
        errorDescription: String?
    ) {
        self.id = id
        self.planID = planID
        self.originalPath = originalPath
        self.targetPath = targetPath
        self.status = status
        self.detail = detail
        self.errorDescription = errorDescription
    }
}
