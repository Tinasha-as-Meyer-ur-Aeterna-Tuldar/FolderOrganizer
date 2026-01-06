//
//  RenamePlanBuilder.swift
//  FolderOrganizer
//

import Foundation

final class RenamePlanBuilder {

    func build(
        originalURL: URL,
        originalName: String,
        normalizedName: String,
        roles: [DetectedRole],
        context: ContextInfo
    ) -> RenamePlan {

        // ✅ destinationURL は Builder の責務
        let destinationURL = originalURL
            .deletingLastPathComponent()
            .appendingPathComponent(normalizedName)

        return RenamePlan(
            originalURL: originalURL,
            destinationURL: destinationURL,
            originalName: originalName,
            normalizedName: normalizedName,
            roles: roles,
            context: context
        )
    }
}
