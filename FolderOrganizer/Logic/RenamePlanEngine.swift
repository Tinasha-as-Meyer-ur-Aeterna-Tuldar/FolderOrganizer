//
// Domain/RenamePlanEngine.swift
//
import Foundation

final class RenamePlanEngine {

    private let builder: RenamePlanBuilder

    init(builder: RenamePlanBuilder) {
        self.builder = builder
    }

    func generatePlan(for url: URL) -> RenamePlan {

        // MARK: - Original
        let originalName = url.lastPathComponent

        // MARK: - Normalize（★ここが修正点）
        let normalizedName = NameNormalizer.normalize(originalName)

        // MARK: - Role Detection
        let roles = RoleDetector.detect(from: normalizedName)

        // MARK: - Context
        let parent = url.deletingLastPathComponent()
        let parentName = parent.lastPathComponent

        let detectedAuthorFolderName: String? =
            parentName.isEmpty ? nil : parentName

        let isUnderAuthorFolder = (detectedAuthorFolderName != nil)

        let context = ContextInfo(
            currentParent: parent,
            isUnderAuthorFolder: isUnderAuthorFolder,
            detectedAuthorFolderName: detectedAuthorFolderName,
            duplicateNameExists: false
        )

        // MARK: - Build RenamePlan
        return builder.build(
            originalURL: url,
            originalName: originalName,
            normalizedName: normalizedName,
            roles: roles,
            context: context
        )
    }
}
