//
//  ApplyPreflightChecker.swift
//  FolderOrganizer
//

import Foundation

enum ApplyPreflightChecker {

    // MARK: - Public

    static func run(items: [RenamePlanExport]) -> [RenameExportIssue] {
        var issues: [RenameExportIssue] = []

        issues += detectFinalPathCollisions(items: items)
        issues += detectInvalidNames(items: items)

        return issues
    }

    // MARK: - Checks

    /// 最終パス重複チェック
    private static func detectFinalPathCollisions(
        items: [RenamePlanExport]
    ) -> [RenameExportIssue] {

        let grouped = Dictionary(grouping: items) {
            $0.targetParentPath + "/" + $0.targetName
        }

        return grouped
            .filter { $0.value.count > 1 }
            .map { key, _ in
                RenameExportIssue(
                    level: .error,
                    title: "パス衝突",
                    message: "最終パスが重複しています: \(key)",
                    originalName: "(collision)",
                    normalizedName: "(collision)"
                )
            }
    }

    /// 無効な名前チェック
    private static func detectInvalidNames(
        items: [RenamePlanExport]
    ) -> [RenameExportIssue] {

        items.compactMap { export in
            let name = export.targetName.trimmingCharacters(in: .whitespaces)

            if name.isEmpty || name == "." || name == ".." {
                return RenameExportIssue(
                    level: .error,
                    title: "無効な名前",
                    message: "無効なフォルダ名です: \(export.targetName)",
                    originalName: export.originalName,
                    normalizedName: export.targetName
                )
            }
            return nil
        }
    }
}
