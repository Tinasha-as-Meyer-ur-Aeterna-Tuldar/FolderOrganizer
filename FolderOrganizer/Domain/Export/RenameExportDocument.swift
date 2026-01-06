//
//  RenameExportDocument.swift
//  FolderOrganizer
//

import Foundation

struct RenameExportDocument: Codable {

    let version: ExportVersion
    let exportedAt: Date

    let rootFolderPath: String
    let items: [RenamePlanExport]
    let issues: [RenameExportIssue]

    // MARK: - Summary

    var totalCount: Int {
        items.count
    }

    var renamedCount: Int {
        items.filter { $0.originalName != $0.normalizedName }.count
    }

    var unchangedCount: Int {
        items.filter { $0.originalName == $0.normalizedName }.count
    }

    var warningCount: Int {
        issues.filter { $0.level == .warning }.count
    }

    var errorCount: Int {
        issues.filter { $0.level == .error }.count
    }

    var hasBlockingErrors: Bool {
        issues.contains(where: { $0.isFatal })
    }
}
