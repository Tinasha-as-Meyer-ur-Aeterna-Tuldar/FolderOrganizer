// Domain/Apply/ApplyResult.swift
//
// Apply の結果 1件分。
// ✅ 重要：既存コード互換のため、旧API（plan / undoInfo）を提供する。
// - ApplyResultExport が result.plan / result.undoInfo を参照しているため
// - UndoInfo は RollbackInfo.Move をそのまま使う（from=適用後, to=元）
//

import Foundation

struct ApplyResult: Identifiable {

    // MARK: - Identity

    let id: UUID

    // MARK: - Core（旧互換の中心）

    /// 旧: result.plan
    let plan: RenamePlan

    /// 旧: result.undoInfo（成功時のみ）
    let undoInfo: RollbackInfo.Move?

    /// 成功/失敗/スキップ
    let status: Status

    // MARK: - Status

    enum Status {
        case skipped(reason: String)
        case success
        case failure(ApplyError)
    }

    // MARK: - Computed（旧互換）

    var isSuccess: Bool {
        if case .success = status { return true }
        return false
    }

    var isSkipped: Bool {
        if case .skipped = status { return true }
        return false
    }

    var error: ApplyError? {
        if case .failure(let e) = status { return e }
        return nil
    }

    // MARK: - Init

    init(
        id: UUID = UUID(),
        plan: RenamePlan,
        undoInfo: RollbackInfo.Move?,
        status: Status
    ) {
        self.id = id
        self.plan = plan
        self.undoInfo = undoInfo
        self.status = status
    }

    // MARK: - Factory

    static func skipped(plan: RenamePlan, reason: String) -> ApplyResult {
        ApplyResult(
            plan: plan,
            undoInfo: nil,
            status: .skipped(reason: reason)
        )
    }

    static func success(plan: RenamePlan) -> ApplyResult {
        // Undo 用（Apply後の場所 -> 元の場所）
        let move = RollbackInfo.Move(from: plan.targetURL, to: plan.originalURL)

        return ApplyResult(
            plan: plan,
            undoInfo: move,
            status: .success
        )
    }

    static func failure(plan: RenamePlan, error: ApplyError) -> ApplyResult {
        ApplyResult(
            plan: plan,
            undoInfo: nil,
            status: .failure(error)
        )
    }

    // MARK: - Rollback Builder

    /// 成功したものだけで RollbackInfo を生成
    static func makeRollbackInfo(from results: [ApplyResult]) -> RollbackInfo {
        let moves = results.compactMap { $0.undoInfo }
        return RollbackInfo(moves: moves)
    }
}
