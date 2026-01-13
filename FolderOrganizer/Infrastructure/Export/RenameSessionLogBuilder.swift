// Infrastructure/Export/RenameSessionLogBuilder.swift
//
// 既存 Domain（RenamePlan / ApplyResult）から Export DTO（RenameSessionLog）を組み立てる Builder
// - Domain を Codable にしない方針の中核
// - v0.2-1 は Apply ログだけを対象にする（Undo は v0.2-2 以降）
//

import Foundation

protocol RenameSessionLogBuilding {
    func build(
        rootURL: URL,
        plans: [RenamePlan],
        results: [ApplyResult]
    ) -> RenameSessionLog
}

final class RenameSessionLogBuilder: RenameSessionLogBuilding {

    func build(
        rootURL: URL,
        plans: [RenamePlan],
        results: [ApplyResult]
    ) -> RenameSessionLog {

        let planLogs: [RenamePlanLog] = plans.map { plan in
            RenamePlanLog(
                id: plan.id,
                originalPath: plan.originalURL.path,
                targetPath: plan.targetURL.path,
                originalName: plan.originalName,
                normalizedName: plan.normalizedName,
                isChanged: plan.isChanged,
                source: "unspecified",
                warnings: plan.normalizeResult.warnings
            )
        }

        let resultLogs: [ApplyResultLog] = results.map { result in
            let plan = result.plan

            switch result.status {
            case .success:
                return ApplyResultLog(
                    planID: plan.id,
                    originalPath: plan.originalURL.path,
                    targetPath: plan.targetURL.path,
                    status: .success,
                    detail: nil,
                    errorDescription: nil
                )

            case .skipped(let reason):
                return ApplyResultLog(
                    planID: plan.id,
                    originalPath: plan.originalURL.path,
                    targetPath: plan.targetURL.path,
                    status: .skipped,
                    detail: reason,
                    errorDescription: nil
                )

            case .failure(let error):
                // ApplyError は Codable にしない。最低限、読みやすい文字列だけ残す。
                let message = (error as NSError).localizedDescription
                return ApplyResultLog(
                    planID: plan.id,
                    originalPath: plan.originalURL.path,
                    targetPath: plan.targetURL.path,
                    status: .failure,
                    detail: nil,
                    errorDescription: message
                )
            }
        }

        return RenameSessionLog(
            schemaVersion: 1,
            sessionID: UUID(),
            createdAt: Date(),
            rootPath: rootURL.path,
            plans: planLogs,
            applyResults: resultLogs
        )
    }
}
