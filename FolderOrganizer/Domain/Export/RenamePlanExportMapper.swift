//
//  RenamePlanExportMapper.swift
//  FolderOrganizer
//

import Foundation

/// Domain（RenamePlan） → DTO（RenamePlanExport）変換
enum RenamePlanExportMapper {

    static func map(_ plan: RenamePlan) -> RenamePlanExport {
        RenamePlanExport(
            originalPath: plan.originalURL.path,
            originalName: plan.originalName,
            normalizedName: plan.normalizedName,
            targetParentPath: plan.destinationURL.deletingLastPathComponent().path,
            targetName: plan.destinationURL.lastPathComponent
        )
    }
}
