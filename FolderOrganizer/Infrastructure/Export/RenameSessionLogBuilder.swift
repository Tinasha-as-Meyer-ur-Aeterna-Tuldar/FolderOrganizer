// Infrastructure/Export/RenameSessionLogBuilder.swift
//
// Domain（RenamePlan / ApplyResult / RollbackInfo）から
// RenameSessionLog（Export DTO）を構築する Builder。
// - UI 状態（RenameSession）は参照しない
// - Apply 直後の AutoSave では Undo は未実行のため executedAt は常に nil
//

import Foundation

protocol RenameSessionLogBuilding {
    func build(
        rootURL: URL,
        plans: [RenamePlan],
        applyResults: [ApplyResult],
        rollbackInfo: RollbackInfo?
    ) -> RenameSessionLog
}

final class RenameSessionLogBuilder: RenameSessionLogBuilding {

    // MARK: - Build

    func build(
        rootURL: URL,
        plans: [RenamePlan],
        applyResults: [ApplyResult],
        rollbackInfo: RollbackInfo?
    ) -> RenameSessionLog {

        RenameSessionLog(
            schemaVersion: "0.2",
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown",
            exportedAt: Date(),
            session: buildSessionInfo(rootURL: rootURL, plans: plans),
            plans: buildPlanLogs(from: plans),
            applyResults: buildApplyResultLogs(from: applyResults),
            undo: buildUndoLog(from: rollbackInfo),
            learningHints: LearningHintsLog(
                editedCount: plans.filter { $0.isChanged }.count,
                autoAcceptedCount: plans.filter { !$0.isChanged }.count,
                patterns: []
            )
        )
    }

    // MARK: - Session Info

    private func buildSessionInfo(
        rootURL: URL,
        plans: [RenamePlan]
    ) -> RenameSessionInfo {

        let total = plans.count
        let changed = plans.filter { $0.isChanged }.count
        let skipped = total - changed

        return RenameSessionInfo(
            id: UUID(),
            rootPath: rootURL.path,
            scannedAt: Date(),
            appliedAt: Date(),
            summary: .init(
                total: total,
                changed: changed,
                skipped: skipped
            )
        )
    }

    // MARK: - Plans

    private func buildPlanLogs(from plans: [RenamePlan]) -> [RenamePlanLog] {
        plans.map { plan in
            RenamePlanLog(
                id: plan.id,
                originalName: plan.originalName,
                normalizedName: plan.normalizedName,
                userEdited: plan.isChanged,
                issues: plan.item.issues.map { $0.rawValue },
                diff: .init(from: plan.originalName, to: plan.normalizedName)
            )
        }
    }

    // MARK: - Apply Results

    private func buildApplyResultLogs(from results: [ApplyResult]) -> [ApplyResultLog] {
        results.map { result in
            switch result.status {

            case .success:
                return ApplyResultLog(
                    planId: result.plan.id,
                    status: .success,
                    fromPath: result.plan.originalURL.path,
                    toPath: result.plan.targetURL.path,
                    reason: nil
                )

            case .skipped(let reason):
                return ApplyResultLog(
                    planId: result.plan.id,
                    status: .skipped,
                    fromPath: nil,
                    toPath: nil,
                    reason: reason
                )

            case .failure(let error):
                return ApplyResultLog(
                    planId: result.plan.id,
                    status: .failure,
                    fromPath: nil,
                    toPath: nil,
                    reason: error.localizedDescription
                )
            }
        }
    }

    // MARK: - Undo

    private func buildUndoLog(from rollbackInfo: RollbackInfo?) -> UndoResultLog {

        guard let rollbackInfo else {
            return UndoResultLog(
                available: false,
                executedAt: nil,
                moves: []
            )
        }

        let moves = rollbackInfo.moves.map {
            UndoResultLog.Move(
                fromPath: $0.from.path,
                toPath: $0.to.path
            )
        }

        // Apply 直後の AutoSave なので Undo はまだ未実行 → executedAt は nil
        return UndoResultLog(
            available: true,
            executedAt: nil,
            moves: moves
        )
    }
}
