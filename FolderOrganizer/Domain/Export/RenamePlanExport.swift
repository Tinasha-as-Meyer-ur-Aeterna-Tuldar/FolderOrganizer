// Domain/Export/RenamePlanExport.swift
//
// RenamePlan の Export / Import 用 DTO。
// JSON 保存・読み込み専用で、Domain モデルとは責務を分離する。
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

    /// Export DTO → Domain Model
    func toDomain() -> RenamePlan {

        let originalURL = URL(fileURLWithPath: originalPath)
        let destinationURL =
            URL(fileURLWithPath: targetParentPath)
                .appendingPathComponent(targetName)

        let context = ContextInfo(
            currentParent: originalURL.deletingLastPathComponent(),
            isUnderAuthorFolder: false,
            detectedAuthorFolderName: nil,
            duplicateNameExists: false
        )

        // Export では warnings / rules を完全復元できないため
        // 最低限の NameNormalizer.Result を生成
        let normalizeResult = NameNormalizer.Result(
            normalized: normalizedName,
            warnings: [],
            appliedRules: []
        )

        return RenamePlan(
            originalURL: originalURL,
            destinationURL: destinationURL,
            originalName: originalName,
            normalizedName: normalizedName,
            roles: [],
            context: context,
            normalizeResult: normalizeResult
        )
    }
}
