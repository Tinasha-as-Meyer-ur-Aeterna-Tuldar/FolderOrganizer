//
//  DetectedRole.swift
//  FolderOrganizer
//

import Foundation

struct DetectedRole: Identifiable, Hashable {

    let id: UUID
    let role: Role
    let source: RoleSource

    init(
        id: UUID = UUID(),
        role: Role,
        source: RoleSource
    ) {
        self.id = id
        self.role = role
        self.source = source
    }
}
