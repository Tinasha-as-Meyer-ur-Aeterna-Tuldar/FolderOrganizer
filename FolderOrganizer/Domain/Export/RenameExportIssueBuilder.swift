//
//  RenameExportIssueBuilder.swift
//  FolderOrganizer
//

import Foundation

enum RenameExportIssueBuilder {

    static func build(from plans: [RenamePlan]) -> [RenameExportIssue] {
        plans.flatMap { buildIssues(from: $0) }
    }

    // MARK: - Private

    private static func buildIssues(from plan: RenamePlan) -> [RenameExportIssue] {
        var issues: [RenameExportIssue] = []

        // NormalizeWarning（String）→ ExportIssue（warning）
        for warning in plan.normalizeResult.warnings {
            issues.append(
                RenameExportIssue(
                    level: .warning,
                    title: "正規化警告",
                    message: warning,              // ← ここが修正点
                    originalName: plan.originalName,
                    normalizedName: plan.normalizedName
                )
            )
        }

        // ❌ エラー系は将来ここに追加
        // plan.normalizeResult.errors など

        return issues
    }
}
