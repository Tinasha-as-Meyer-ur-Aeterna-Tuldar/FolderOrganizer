// Services/ApplyService.swift
//
// RenamePlan を 1件ずつ Apply するシンプル Service。
// ⚠️ 旧 ApplyResult(init: isSuccess:error:undoInfo:) を使わない
// ✅ ApplyResult の Factory メソッドを使う
//

import Foundation

final class ApplyService {

    // MARK: - Dependencies

    private let fileManager: FileManager

    // MARK: - Init

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    // MARK: - Public

    func apply(plans: [RenamePlan]) -> [ApplyResult] {
        plans.map { applySingle($0) }
    }

    // MARK: - Internal

    private func applySingle(_ plan: RenamePlan) -> ApplyResult {

        let fromURL = plan.originalURL
        let toURL = plan.targetURL

        // 変更なし → スキップ
        if plan.isChanged == false {
            return ApplyResult.skipped(
                plan: plan,
                reason: "変更なし"
            )
        }

        // 既に存在 → 失敗
        if fileManager.fileExists(atPath: toURL.path) {
            return ApplyResult.failure(
                plan: plan,
                error: .destinationAlreadyExists(toURL)
            )
        }

        // move 実行
        do {
            try fileManager.moveItem(at: fromURL, to: toURL)
            return ApplyResult.success(plan: plan)
        } catch {
            return ApplyResult.failure(
                plan: plan,
                error: .fileMoveFailed(
                    from: fromURL,
                    to: toURL,
                    message: String(describing: error)
                )
            )
        }
    }
}
