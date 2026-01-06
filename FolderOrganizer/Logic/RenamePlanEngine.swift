//
//  RenamePlanEngine.swift
//  FolderOrganizer
//

import Foundation

final class RenamePlanEngine {

    private let builder = RenamePlanBuilder()

    func generatePlan(for url: URL) -> RenamePlan {

        let originalName = url.lastPathComponent

        // MARK: - Normalize
        let normalizeResult = NameNormalizer.normalize(originalName)
        let normalizedName = normalizeResult.value

        // MARK: - Role Detection
        let roleResult = RoleDetector.detect(from: normalizedName)

        // ✅ Role → DetectedRole に変換
        let detectedRoles: [DetectedRole] = roleResult.roles.map {
            DetectedRole(
                role: $0,
                source: .detected
            )
        }

        // MARK: - Context
        let parentURL = url.deletingLastPathComponent()
        let parentName = parentURL.lastPathComponent

        let detectedAuthorFolderName: String? =
            parentName.isEmpty ? nil : parentName

        let isUnderAuthorFolder = (detectedAuthorFolderName != nil)

        let context = ContextInfo(
            currentParent: parentURL,
            isUnderAuthorFolder: isUnderAuthorFolder,
            detectedAuthorFolderName: detectedAuthorFolderName,
            duplicateNameExists: false
        )

        // MARK: - Build RenamePlan
        return builder.build(
            originalURL: url,
            originalName: originalName,
            normalizedName: normalizedName,
            roles: detectedRoles,   // ✅ 修正点
            context: context
        )
    }
}
