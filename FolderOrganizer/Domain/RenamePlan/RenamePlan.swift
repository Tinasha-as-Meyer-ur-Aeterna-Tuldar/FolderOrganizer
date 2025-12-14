import Foundation

/// DryRun の最終成果物
/// 実際のファイル操作は一切行わない
struct RenamePlan: Identifiable {

    let id = UUID()

    /// 元のフォルダ / ファイル URL
    let originalURL: URL

    /// 元の名前（表示用）
    let originalName: String

    /// 正規化後の名前（解析用）
    let normalizedName: String

    /// 検出された作者名
    let detectedAuthor: String?

    /// 確定タイトル
    let title: String

    /// 確定 subtitle（安全に使える）
    let subtitle: String?

    /// 不確定 subtitle（判断保留）
    let maybeSubtitle: String?

    /// 移動先の親フォルダ（DryRun）
    let targetParentFolder: URL

    /// 最終的な名前（DryRun）
    let targetName: String

    /// 注意・警告
    let warnings: [RenameWarning]
}

// MARK: - Copy helpers（重要）

extension RenamePlan {

    /// 指定した warning を除外した新しい RenamePlan を返す
    func removingWarnings(
        where shouldRemove: (RenameWarning) -> Bool
    ) -> RenamePlan {

        RenamePlan(
            originalURL: originalURL,
            originalName: originalName,
            normalizedName: normalizedName,
            detectedAuthor: detectedAuthor,
            title: title,
            subtitle: subtitle,
            maybeSubtitle: maybeSubtitle,
            targetParentFolder: targetParentFolder,
            targetName: targetName,
            warnings: warnings.filter { !shouldRemove($0) }
        )
    }

    /// authorNotDetected を解除した RenamePlan
    func allowingWithoutAuthor() -> RenamePlan {
        removingWarnings { warning in
            if case .authorNotDetected = warning { return true }
            return false
        }
    }
}
