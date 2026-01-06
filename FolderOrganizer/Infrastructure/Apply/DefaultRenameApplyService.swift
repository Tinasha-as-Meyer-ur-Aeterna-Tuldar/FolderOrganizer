//
//  DefaultRenameApplyService.swift
//  FolderOrganizer
//

import Foundation

final class DefaultRenameApplyService: RenameApplyService {

    private let fileManager: FileManager = .default

    func apply(
        plans: [RenamePlan],
        completion: @escaping ([ApplyResult]) -> Void
    ) {
        var results: [ApplyResult] = []

        for plan in plans {
            do {
                // MARK: - 1. Rename（move）
                try fileManager.moveItem(
                    at: plan.originalURL,
                    to: plan.destinationURL
                )

                // MARK: - 2. Rollback 情報作成（Undo用）
                let rollback = RollbackInfo(
                    moves: [
                        RollbackInfo.Move(
                            from: plan.destinationURL, // Apply後
                            to: plan.originalURL       // 元に戻す先
                        )
                    ]
                )

                // MARK: - 3. 成功 Result
                let result: ApplyResult = .success(
                    plan: plan,
                    destinationURL: plan.destinationURL,
                    rollback: rollback
                )

                results.append(result)

            } catch {
                // MARK: - 4. 失敗 Result
                let result: ApplyResult = .failure(error: error)
                results.append(result)
            }
        }

        completion(results)
    }
}
