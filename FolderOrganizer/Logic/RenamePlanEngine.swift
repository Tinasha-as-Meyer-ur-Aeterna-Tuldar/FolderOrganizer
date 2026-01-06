// Logic/RenamePlanEngine.swift
//
// 1つの URL（フォルダ/ファイル）から RenamePlan を生成する中核エンジン。
// - NameNormalizer で正規化（Result を保持）
// - RoleDetector で役割推定
// - 親フォルダ等の Context を作り
// - RenamePlanBuilder に渡して RenamePlan を組み立てる
//
// ここは「変換のハブ」なので、NameNormalizer.Result のプロパティ名変更が入ったら
// 追従ポイントは基本ここ（normalized / warnings など）。
//

import Foundation

final class RenamePlanEngine {

    private let builder = RenamePlanBuilder()

    func generatePlan(for url: URL) -> RenamePlan {

        let originalName = url.lastPathComponent

        // MARK: - Normalize
        // NameNormalizer は String ではなく Result を返す
        let normalizeResult = NameNormalizer.normalize(originalName)

        // 旧：normalizeResult.value  → 新：normalizeResult.normalized
        let normalizedName = normalizeResult.normalized

        // MARK: - Role Detection
        let roleResult = RoleDetector.detect(from: normalizedName)

        // ✅ Role -> DetectedRole に変換
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
        // normalizeResult（warnings 等）を保持したいので、builder には Result を渡す前提
        return builder.build(
            originalURL: url,
            originalName: originalName,
            normalizedName: normalizedName,
            roles: detectedRoles,
            context: context,
            normalizeResult: normalizeResult
        )
    }
}
