// Logic/RenamePlanBuilder.swift
//
// RenamePlanEngine から渡された情報をまとめ、
// 最終的な RenamePlan を生成するビルダー。
//

import Foundation

final class RenamePlanBuilder {

    func build(
        originalURL: URL,
        originalName: String,
        normalizedName: String,
        roles: [DetectedRole],
        context: ContextInfo,
        normalizeResult: NameNormalizer.Result
    ) -> RenamePlan {

        // リネーム後の URL をここで確定
        let destinationURL =
            context.currentParent.appendingPathComponent(normalizedName)

        return RenamePlan(
            originalURL: originalURL,
            destinationURL: destinationURL,
            originalName: originalName,
            normalizedName: normalizedName,
            roles: roles,
            context: context,
            normalizeResult: normalizeResult
        )
    }
}
