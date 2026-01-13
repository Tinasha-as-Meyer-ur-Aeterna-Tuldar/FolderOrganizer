//
//  RenameExportIssue.swift
//  FolderOrganizer
//

import Foundation

/// Export / Apply 前チェックで検出された Issue
struct RenameExportIssue: Codable, Identifiable {

    let id: UUID
    let level: IssueLevel
    let title: String
    let message: String
    let originalName: String
    let normalizedName: String

    init(
        level: IssueLevel,
        title: String,
        message: String,
        originalName: String,
        normalizedName: String
    ) {
        self.id = UUID()
        self.level = level
        self.title = title
        self.message = message
        self.originalName = originalName
        self.normalizedName = normalizedName
    }

    /// Apply / Export を止めるべき致命エラーか
    var isFatal: Bool {
        level == .error
    }
}
