//
//  RenameWarning.swift
//  FolderOrganizer
//

import Foundation

/// リネーム時の注意・警告
struct RenameWarning: Identifiable, Hashable, Codable {
    let id: UUID
    let message: String

    init(id: UUID = UUID(), message: String) {
        self.id = id
        self.message = message
    }
}
