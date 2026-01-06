//
//  RenamePlanExport.swift
//  FolderOrganizer
//

import Foundation

/// RenamePlan の Export / Import 用 DTO
struct RenamePlanExport: Codable {

    // MARK: - Stored (Export)

    let originalPath: String
    let originalName: String
    let normalizedName: String
    let targetParentPath: String
    let targetName: String

    // MARK: - Back to Domain

    func toDomain() -> RenamePlan {

        let originalURL = URL(fileURLWithPath: originalPath)
        let destinationURL = URL(fileURLWithPath: targetParentPath)
            .appendingPathComponent(targetName)

        let context = ContextInfo(
            currentParent: originalURL.deletingLastPathComponent(),
            isUnderAuthorFolder: false,
            detectedAuthorFolderName: nil,
            duplicateNameExists: false
        )

        return RenamePlan(
            id: UUID(),
            originalURL: originalURL,
            destinationURL: destinationURL,
            originalName: originalName,
            normalizedName: normalizedName,
            roles: [],
            context: context
        )
    }
}
