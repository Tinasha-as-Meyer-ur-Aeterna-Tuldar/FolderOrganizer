import Foundation

protocol RenamePlanBuilder {

    /// 文脈と役割から DryRun 用 RenamePlan を構築する
    func build(
        originalURL: URL,
        normalizedName: String,
        roles: RoleDetectionResult,
        context: ContextInfo
    ) -> RenamePlan
}

final class DefaultRenamePlanBuilder: RenamePlanBuilder {

    func build(
        originalURL: URL,
        normalizedName: String,
        roles: RoleDetectionResult,
        context: ContextInfo
    ) -> RenamePlan {

        var warnings: [RenameWarning] = []

        // MARK: - Author warning

        if roles.author == nil {
            warnings.append(.authorNotDetected)
        }

        // MARK: - Subtitle warning

        if let maybe = roles.maybeSubtitle {
            warnings.append(.ambiguousSubtitle(maybe))
        }

        // MARK: - Target Parent

        let targetParent = resolveTargetParent(
            roles: roles,
            context: context
        )

        // MARK: - Target Name

        let targetName = buildTargetName(
            roles: roles,
            context: context
        )

        // MARK: - Duplicate name warning（DryRun用・存在チェックはまだしない）
        // → 将来 Apply フェーズで FileManager と連携

        return RenamePlan(
            originalURL: originalURL,
            originalName: originalURL.lastPathComponent,
            normalizedName: normalizedName,
            detectedAuthor: roles.author,
            title: roles.title,
            subtitle: roles.subtitle,
            maybeSubtitle: roles.maybeSubtitle,
            targetParentFolder: targetParent,
            targetName: targetName,
            warnings: warnings
        )
    }
}

private extension DefaultRenamePlanBuilder {

    // MARK: - Parent Resolution

    /// 移動先の親フォルダを決定
    func resolveTargetParent(
        roles: RoleDetectionResult,
        context: ContextInfo
    ) -> URL {

        // 作者フォルダ直下 → そのまま
        if context.isUnderAuthorFolder {
            return context.currentParent
        }

        // 作者未検出 → 移動しない
        guard let author = roles.author else {
            return context.currentParent
        }

        // 作者フォルダを新規作成する想定（DryRun）
        return context.currentParent.appendingPathComponent(author)
    }

    // MARK: - Target Name

    /// 最終的なフォルダ名を構築
    func buildTargetName(
        roles: RoleDetectionResult,
        context: ContextInfo
    ) -> String {

        var components: [String] = []

        // title は必須
        components.append(roles.title)

        // 確定 subtitle のみ追加
        if let subtitle = roles.subtitle {
            components.append("(\(subtitle))")
        }

        return components.joined(separator: " ")
    }
}
