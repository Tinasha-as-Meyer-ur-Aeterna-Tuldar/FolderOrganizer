//
//  DefaultRenameExportService.swift
//  FolderOrganizer
//

import Foundation

final class DefaultRenameExportService {

    func export(
        plans: [RenamePlan],
        rootFolderURL: URL
    ) -> RenameExportDocument {

        let exportPlans: [RenamePlanExport] = plans.map {
            RenamePlanExportMapper.map($0)
        }

        let issues: [RenameExportIssue] = RenameExportIssueBuilder.build(from: plans)

        return RenameExportDocument(
            version: .v1,
            exportedAt: Date(),
            rootFolderPath: rootFolderURL.path,
            items: exportPlans,
            issues: issues
        )
    }
}

