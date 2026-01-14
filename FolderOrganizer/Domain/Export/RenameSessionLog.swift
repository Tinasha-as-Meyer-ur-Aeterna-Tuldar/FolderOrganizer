// Domain/Export/RenameSessionLog.swift
//
// Rename セッション全体の JSON Export 用 DTO
//

import Foundation

struct RenameSessionLog: Codable {

    let schemaVersion: String
    let appVersion: String
    let exportedAt: Date

    let session: RenameSessionInfo
    let plans: [RenamePlanLog]
    let applyResults: [ApplyResultLog]
    let undo: UndoResultLog

    let learningHints: LearningHintsLog
}
