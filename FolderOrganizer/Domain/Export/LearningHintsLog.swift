// Domain/Export/LearningHintsLog.swift
//
// v0.2 では保存のみ（未使用）
//

import Foundation

struct LearningHintsLog: Codable {

    let editedCount: Int
    let autoAcceptedCount: Int
    let patterns: [Pattern]

    struct Pattern: Codable {
        let original: String
        let normalized: String
        let userAccepted: Bool
    }
}
