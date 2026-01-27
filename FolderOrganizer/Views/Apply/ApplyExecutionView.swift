// FolderOrganizer/Views/Apply/ApplyExecutionView.swift
//
// Apply 実行画面
// - 新設計：plan.originalURL.lastPathComponent を使用
//

import SwiftUI

struct ApplyExecutionView: View {

    let rootURL: URL
    let plans: [RenamePlan]
    let applyService: RenameApplyService

    let onFinish: (_ results: [ApplyResult], _ rollbackInfo: RollbackInfo) -> Void
    let onClose: () -> Void

    @State private var isExecuting: Bool = false
    @State private var results: [ApplyResult] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            header

            Divider()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(plans) { plan in
                        Text(plan.originalURL.lastPathComponent)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 13, design: .monospaced))
                    }
                }
                .padding()
            }

            Divider()

            footer
        }
        .padding()
        .frame(minWidth: 720, minHeight: 520)
        .onAppear {
            runIfNeeded()
        }
    }

    // MARK: - Parts

    private var header: some View {
        HStack {
            Text("Apply 実行")
                .font(.headline)

            Spacer()

            Button("閉じる") {
                onClose()
            }
        }
    }

    private var footer: some View {
        HStack {
            if isExecuting {
                ProgressView()
            } else {
                Text("準備完了")
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }

    // MARK: - Run

    private func runIfNeeded() {
        guard !isExecuting else { return }
        isExecuting = true

        applyService.apply(plans: plans) { results, rollbackInfo in
            self.results = results
            self.isExecuting = false
            onFinish(results, rollbackInfo)
        }
    }
}
