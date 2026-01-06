//
//  ApplyExecutionView.swift
//  FolderOrganizer
//

import SwiftUI

struct ApplyExecutionView: View {

    let plans: [RenamePlan]
    let applyService: RenameApplyService
    let onFinish: ([ApplyResult]) -> Void

    @State private var isRunning: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Apply 実行中")
                .font(.headline)

            ProgressView()
                .progressViewStyle(.linear)

            Text("件数: \(plans.count)")
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(24)
        .onAppear {
            run()
        }
    }

    // MARK: - Execute

    private func run() {
        guard !isRunning else { return }
        isRunning = true

        applyService.apply(plans: plans) { results in
            DispatchQueue.main.async {
                onFinish(results)
            }
        }
    }
}
