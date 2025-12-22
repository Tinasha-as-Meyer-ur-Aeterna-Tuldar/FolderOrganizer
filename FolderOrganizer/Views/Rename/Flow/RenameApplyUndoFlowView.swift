//
// Views/Rename/Flow/RenameApplyUndoFlowView.swift
// Apply → Result → Undo(Confirm/Exec/Result) → 戻る（再Apply可能）
//
import SwiftUI

struct RenameApplyUndoFlowView: View {

    // MARK: - Inputs

    /// Apply 対象
    let plans: [RenamePlan]

    /// Domain / Logic 側サービス（注入）
    let applyService: RenameApplyService
    let undoService: DefaultRenameUndoService

    /// フロー全体を閉じる（Preview に戻る等）
    let onClose: () -> Void


    // MARK: - Flow State

    private enum Step {
        case applyExecution
        case applyResult
        case undoConfirm
        case undoExecution
        case undoResult
    }

    @State private var step: Step = .applyExecution

    @State private var applyResults: [ApplyResult] = []
    @State private var undoResults: [UndoResult] = []


    // MARK: - View

    var body: some View {
        switch step {

        case .applyExecution:
            ApplyExecutionView(
                plans: plans,
                applyService: applyService,
                onFinish: { results in
                    applyResults = results
                    step = .applyResult
                },
                onCancel: {
                    onClose()
                }
            )

        case .applyResult:
            ApplyResultView(
                results: applyResults,
                onUndo: { successResults in
                    // Undo は成功分だけ渡す（設計どおり）
                    applyResults = successResults
                    step = .undoConfirm
                },
                onClose: {
                    // ここで閉じると「Apply完了でPreviewへ戻る」
                    onClose()
                }
            )

        case .undoConfirm:
            UndoConfirmationView(
                applyResults: applyResults,
                onConfirm: {
                    step = .undoExecution
                },
                onCancel: {
                    // ApplyResult に戻す（再確認できる）
                    step = .applyResult
                }
            )

        case .undoExecution:
            UndoExecutionView(
                applyResults: applyResults,
                undoService: undoService,
                onFinish: { results in
                    undoResults = results
                    step = .undoResult
                },
                onCancel: {
                    // キャンセル時は ApplyResult に戻す
                    step = .applyResult
                }
            )

        case .undoResult:
            UndoResultView(
                results: undoResults,
                onClose: {
                    // Undo完了後：ApplyResult に戻す（再Apply 可能）
                    step = .applyResult
                }
            )
        }
    }
}
