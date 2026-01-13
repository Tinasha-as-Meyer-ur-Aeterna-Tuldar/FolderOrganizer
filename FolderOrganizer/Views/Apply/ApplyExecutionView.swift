// Views/Apply/ApplyExecutionView.swift
//
// Apply 実行画面
// - v0.2 UX: 結果サマリは ApplyResultList に集約
//

import SwiftUI

struct ApplyExecutionView: View {

    // MARK: - Dependencies

    let rootURL: URL
    let plans: [RenamePlan]

    let applyService: RenameApplyService
    let autoSaveService: DefaultRenameSessionLogAutoSaveService

    let onClose: () -> Void

    // MARK: - State

    @State private var isExecuting: Bool = false
    @State private var results: [ApplyResult] = []

    // MARK: - Init

    init(
        rootURL: URL,
        plans: [RenamePlan],
        applyService: RenameApplyService,
        autoSaveService: DefaultRenameSessionLogAutoSaveService = DefaultRenameSessionLogAutoSaveService(),
        onClose: @escaping () -> Void
    ) {
        self.rootURL = rootURL
        self.plans = plans
        self.applyService = applyService
        self.autoSaveService = autoSaveService
        self.onClose = onClose
    }

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            if isExecuting {
                ProgressView("適用中…")
                    .progressViewStyle(.linear)
            }

            ApplyResultList(results: results)

            Spacer()

            HStack {
                Spacer()
                Button("閉じる") {
                    onClose()
                }
                .keyboardShortcut(.cancelAction)
            }
        }
        .padding()
        .onAppear {
            executeApplyIfNeeded()
        }
    }

    // MARK: - Apply

    private func executeApplyIfNeeded() {
        guard !isExecuting, results.isEmpty else { return }

        isExecuting = true

        applyService.apply(plans: plans) { applyResults in
            self.results = applyResults
            self.isExecuting = false

            autoSaveService.saveAfterApply(
                rootURL: rootURL,
                plans: plans,
                results: applyResults
            )
        }
    }
}
