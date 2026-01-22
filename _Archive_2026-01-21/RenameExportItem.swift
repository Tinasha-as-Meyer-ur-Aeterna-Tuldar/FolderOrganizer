//
//  RenameExportItem.swift
//  FolderOrganizer
//

import Foundation

struct RenameExportItem: Identifiable, Codable, Hashable {

    let id: UUID

    let originalName: String
    let finalName: String

    let userEdited: Bool
    let flagged: Bool

    let change: Change

    init(
        id: UUID = UUID(),
        originalName: String,
        finalName: String,
        userEdited: Bool,
        flagged: Bool
    ) {
        self.id = id
        self.originalName = originalName
        self.finalName = finalName
        self.userEdited = userEdited
        self.flagged = flagged
        self.change = Change(original: originalName, final: finalName)
    }
}
