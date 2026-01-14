// Domain/Export/UndoResultLog.swift
//
// Undo 情報の Export 用 DTO
//

import Foundation

struct UndoResultLog: Codable {

    let available: Bool
    let executedAt: Date?
    let moves: [Move]

    struct Move: Codable {
        let fromPath: String
        let toPath: String
    }
}
