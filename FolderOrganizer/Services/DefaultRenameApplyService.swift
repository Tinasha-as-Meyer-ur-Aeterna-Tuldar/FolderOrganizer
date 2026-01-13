// Services/DefaultRenameApplyService.swift
//
// RenamePlan を実際にファイル/フォルダへ適用する Service。
// - ApplyResult の Factory メソッドを使って結果を構築する
// - 旧 DSL（.skipped / .failure 直接 append）は使わない
//

import Foundation

final class DefaultRenameApplyService: RenameApplyService {

    // MARK: - Dependencies

    private let fileManager: FileManager

    // MARK: - Init

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    // MARK: - Public

    func apply(
        plans: [RenamePlan],
        completion: @escaping ([ApplyResult]) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let results = self.applySync(plans: plans)

            DispatchQueue.main.async {
                completion(results)
            }
        }
    }

    // MARK: - Core

    private func applySync(plans: [RenamePlan]) -> [ApplyResult] {
        var results: [ApplyResult] = []
        results.reserveCapacity(plans.count)

        for plan in plans {

            let fromURL = plan.originalURL
            let toURL = plan.targetURL

            // 変更なし → スキップ
            if plan.isChanged == false {
                results.append(
                    ApplyResult.skipped(
                        plan: plan,
                        reason: "変更なし"
                    )
                )
                continue
            }

            // 親フォルダ作成（なければ）
            let parent = toURL.deletingLastPathComponent()
            if ensureDirectoryExists(parent) == false {
                results.append(
                    ApplyResult.failure(
                        plan: plan,
                        error: .failedToCreateDirectory(parent)
                    )
                )
                continue
            }

            // 既に存在するなら失敗（上書きしない）
            if fileManager.fileExists(atPath: toURL.path) {
                results.append(
                    ApplyResult.failure(
                        plan: plan,
                        error: .destinationAlreadyExists(toURL)
                    )
                )
                continue
            }

            // move 実行
            do {
                try fileManager.moveItem(at: fromURL, to: toURL)
                results.append(
                    ApplyResult.success(plan: plan)
                )
            } catch {
                results.append(
                    ApplyResult.failure(
                        plan: plan,
                        error: .fileMoveFailed(
                            from: fromURL,
                            to: toURL,
                            message: String(describing: error)
                        )
                    )
                )
            }
        }

        return results
    }

    // MARK: - Helpers

    private func ensureDirectoryExists(_ url: URL) -> Bool {
        var isDir: ObjCBool = false

        if fileManager.fileExists(atPath: url.path, isDirectory: &isDir) {
            return isDir.boolValue
        }

        do {
            try fileManager.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
            return true
        } catch {
            return false
        }
    }
}
