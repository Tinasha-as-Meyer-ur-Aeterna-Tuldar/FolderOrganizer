// Domain/Export/RenamePlanLog.swift
//
// RenamePlan の Export 用 DTO
//

import Foundation

struct RenamePlanLog: Codable, Identifiable {

    let id: UUID
    let originalName: String
    let normalizedName: String
    let userEdited: Bool
    let issues: [String]

    let diff: Diff

    struct Diff: Codable {
        let from: String
        let to: String
    }
}
