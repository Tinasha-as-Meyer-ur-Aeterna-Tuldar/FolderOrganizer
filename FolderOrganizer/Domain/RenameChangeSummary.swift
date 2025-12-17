// RenameChangeSummary.swift
import Foundation

/// 変更の集計（Apply画面のサマリー用）
struct RenameChangeSummary: Hashable {

    // MARK: - Counts
    var total: Int
    var moveCount: Int
    var renameOnlyCount: Int
    var noChangeCount: Int

    /// 「警告あり」= ブロッキング以外の警告数
    var warningCount: Int

    /// 「実行不可」= ブロッキング警告数
    var blockingCount: Int

    // MARK: - Builder
    static func build(from plans: [RenamePlan]) -> RenameChangeSummary {

        var move = 0
        var renameOnly = 0
        var noChange = 0

        var nonBlockingWarnings = 0
        var blockingWarnings = 0

        for plan in plans {

            // ✅ Move 判定（親フォルダが変わるか）
            let originalParent = plan.originalURL.deletingLastPathComponent()
            let isMove = plan.targetParentFolder != originalParent

            // ✅ Rename 判定（最終フォルダ名が変わるか）
            let isRename = plan.targetName != plan.originalName

            if isMove {
                move += 1
            } else if isRename {
                renameOnly += 1
            } else {
                noChange += 1
            }

            // ✅ Warning 判定
            // - blocking: 実行不可（例: 同名衝突など）
            // - nonBlocking: 目視確認が必要（例: subtitle曖昧/作者未検出 など）
            let b = plan.warnings.filter { $0.isBlocking }.count
            let nb = plan.warnings.count - b

            blockingWarnings += b
            nonBlockingWarnings += nb
        }

        return RenameChangeSummary(
            total: plans.count,
            moveCount: move,
            renameOnlyCount: renameOnly,
            noChangeCount: noChange,
            warningCount: nonBlockingWarnings,
            blockingCount: blockingWarnings
        )
    }
}

// MARK: - Warning Severity
extension RenameWarning {

    /// 実行不可にする警告か？
    /// ※ ここはプロジェクトのルールに合わせて増減OK
    var isBlocking: Bool {
        switch self {
        case .duplicateNameExists:
            return true
        default:
            return false
        }
    }
}
