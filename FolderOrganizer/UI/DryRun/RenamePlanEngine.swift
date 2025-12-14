import Foundation

/// RenamePlan を生成するエンジン（DryRunの心臓）
final class RenamePlanEngine {

    init() {}

    func generatePlan(
        for url: URL,
        userDecision: UserSubtitleDecision
    ) -> RenamePlan {

        // MARK: - Original
        let originalName = url.lastPathComponent

        // MARK: - Normalize（まずは String をそのまま使う）
        let normalized = NameNormalizer.normalize(originalName)

        // MARK: - Detect（最小構成）
        let detectedAuthor: String? = nil
        let title = normalized
        let subtitle: String? = nil
        let maybeSubtitle: String? = nil

        // MARK: - Target
        let targetParentFolder = url.deletingLastPathComponent()

        // ★ 確認用パッチ（After が必ず変わる）
        let targetName = DebugNormalizationPatch.applyToTargetName(normalized)

        // MARK: - Warnings
        var warnings: [RenameWarning] = []
        if detectedAuthor == nil {
            warnings.append(.authorNotDetected)
        }

        return RenamePlan(
            originalURL: url,
            originalName: originalName,
            normalizedName: normalized,
            detectedAuthor: detectedAuthor,
            title: title,
            subtitle: subtitle,
            maybeSubtitle: maybeSubtitle,
            targetParentFolder: targetParentFolder,
            targetName: targetName,
            warnings: warnings
        )
    }
}
