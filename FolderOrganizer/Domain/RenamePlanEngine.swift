// Domain/RenamePlanEngine.swift
import Foundation

/// 正規化 → Role判定 → Context解決 → Builderで RenamePlan を組み立てるエンジン
final class RenamePlanEngine {

    // MARK: - Dependencies
    private let builder: RenamePlanBuilder

    // MARK: - Init
    init(builder: RenamePlanBuilder) {
        self.builder = builder
    }

    // MARK: - Public API
    func generatePlan(for url: URL) -> RenamePlan {

        // MARK: - Original
        let originalName = url.lastPathComponent

        // MARK: - Normalize
        let normalization = NameNormalizer.normalize(originalName)
        let normalizedName = normalization.normalizedName

        // MARK: - Role Detection
        let roles = RoleDetector.detect(from: normalizedName)

        // MARK: - Context
        // DryRun 前提：ここでは FS を触らないので duplicateNameExists は false 固定
        // isUnderAuthorFolder / detectedAuthorFolderName も、とりあえず簡易推定で埋める
        let parent = url.deletingLastPathComponent()
        let parentName = parent.lastPathComponent

        // 超簡易：親フォルダ名が空でなければ「作者フォルダっぽい」扱い（後で ContextResolutionService に移す）
        let detectedAuthorFolderName: String? = parentName.isEmpty ? nil : parentName
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
