//
//  Issue.swift
//  FolderOrganizer
//

import Foundation

/// Apply 前チェック（Preflight）などで使われる問題モデル
struct Issue: Identifiable, Hashable, Codable {

    // MARK: - Identity

    let id: UUID
    let itemId: UUID?

    // MARK: - Detail

    let level: Level
    let code: Code?
    let message: String

    // MARK: - Init

    init(
        id: UUID = UUID(),
        level: Level,
        message: String,
        itemId: UUID? = nil,
        code: Code? = nil
    ) {
        self.id = id
        self.level = level
        self.message = message
        self.itemId = itemId
        self.code = code
    }
}

// MARK: - Nested Types

extension Issue {

    enum Level: String, Codable, Hashable {
        case error
        case warning
        case info
    }

    enum Code: String, Codable, Hashable {
        case invalidName
        case duplicate
        case forbiddenCharacter
        case unknown
    }
}
