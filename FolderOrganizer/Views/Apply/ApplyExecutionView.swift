// Views/Apply/ApplyExecutionView.swift
//
// Apply 実行画面
// - v0.2 UX: 結果サマリは ApplyResultList に集約
//

import SwiftUI

struct ApplyExecutionView: View {

    let rootURL: URL
      let plans: [RenamePlan]
      let applyService: RenameApplyService

      let onFinish: (_ results: [ApplyResult], _ rollbackInfo: RollbackInfo) -> Void
      let onClose: () -> Void


    var body: some View {
        VStack(spacing: 0) {

            header

            Divider()

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(plans) { plan in
                        Text(plan.originalName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }

            Divider()

            footer
        }
        // ❌ maxHeight: .infinity は付けない
        .frame(minWidth: 600, minHeight: 400)
    }

    private var header: some View {
        HStack {
            Text("Apply Preview")
                .font(.headline)
            Spacer()
        }
        .padding()
    }

    private var footer: some View {
        HStack {
            Spacer()
            Button("閉じる", action: onClose)
        }
        .padding()
    }
}
