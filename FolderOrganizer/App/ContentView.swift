//
//  ContentView.swift
//  FolderOrganizer
//

import SwiftUI

struct ContentView: View {

    @State private var flowState: RenameFlowState = .preview
    @State private var plans: [RenamePlan] = []

    private let applyService: RenameApplyService = DefaultRenameApplyService()
    private let undoService: RenameUndoService = DefaultRenameUndoService()

    var body: some View {
        VStack {
            switch flowState {

            // MARK: - Preview
            case .preview:
                Button("Apply") {
                    startApply()
                }

            // MARK: - Applying
            case .applying:
                ProgressView("Apply 実行中…")

            // MARK: - Applied
            case .applied(let results):
                RenameApplyUndoFlowView(
                    results: results,
                    onCancel: {
                        flowState = .preview
                    },
                    onStartUndo: { rollback in
                        startUndo(rollback: rollback)
                    },
                    onFinish: {
                        flowState = .preview
                    }
                )

            // MARK: - Undoing
            case .undoing:
                ProgressView("Undo 実行中…")
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }

    // MARK: - Apply

    private func startApply() {
        flowState = .applying

        applyService.apply(plans: plans) { results in
            DispatchQueue.main.async {
                flowState = .applied(results: results)
            }
        }
    }

    // MARK: - Undo

    private func startUndo(rollback: RollbackInfo) {
        flowState = .undoing

        undoService.undo(rollback: rollback) { _ in
            DispatchQueue.main.async {
                flowState = .preview
            }
        }
    }
}
