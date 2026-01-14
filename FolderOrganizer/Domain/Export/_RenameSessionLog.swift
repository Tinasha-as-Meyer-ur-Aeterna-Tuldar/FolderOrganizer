// Domain/Export/RenameSessionLog.swift
//
// JSON Export 用のセッションログ（DTO）
// - 既存 Domain（RenamePlan / ApplyResult 等）を Codable にしない
// - schemaVersion を最初から持たせ、将来の互換性を守る
// - 1 Apply = 1 JSON ファイル（自動保存）を想定
//

import Foundation

struct RenameSessionLog: Codable, Hashable {

    // MARK: - Schema

    /// JSON スキーマのバージョン（破壊的変更に備える）
    let schemaVersion: Int

    // MARK: - Identity

    let sessionID: UUID

    // MARK: - Meta

    let createdAt: Date

    /// ユーザーが選択したルートフォルダ（URL は JSON に直接出さず、String 化して保持）
    let rootPath: String

    // MARK: - Payload

    let plans: [RenamePlanLog]
    let applyResults: [ApplyResultLog]

    // MARK: - Init

    init(
        schemaVersion: Int = 1,
        sessionID: UUID = UUID(),
        createdAt: Date = Date(),
        rootPath: String,
        plans: [RenamePlanLog],
        applyResults: [ApplyResultLog]
    ) {
        self.schemaVersion = schemaVersion
        self.sessionID = sessionID
        self.createdAt = createdAt
        self.rootPath = rootPath
        self.plans = plans
        self.applyResults = applyResults
    }
}
