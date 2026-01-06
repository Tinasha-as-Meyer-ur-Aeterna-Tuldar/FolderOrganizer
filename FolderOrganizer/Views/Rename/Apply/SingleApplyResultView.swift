//
//  SingleApplyResultView.swift
//  FolderOrganizer
//

import SwiftUI

struct SingleApplyResultView: View {

    let plan: RenamePlan

    @State private var applyResult: ApplyResult?
    @State private var undoResult: UndoResult?

    private let applyService = DefaultRenameApplyService()
    private let undoService  = DefaultRenameUndoService()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Header
            Text("1件だけ Apply（安全確認）")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                Text("Before")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(plan.originalName)
                    .font(.system(size: 12, design: .monospaced))

                Text("After")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(plan.destinationURL.lastPathComponent)
                    .fontWeight(.semibold)
            }

            Divider()

            // MARK: - Apply Button
            if applyResult == nil {
                Button {
                    applyOne()
                } label: {
                    Text("この1件だけ Apply")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }

            // MARK: - Apply Result
            if let result = applyResult {
                VStack(alignment: .leading, spacing: 8) {
                    switch result {

                    case .success(_, let destinationURL, _):
                        Label("Apply 成功", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)

                        Text(destinationURL.lastPathComponent)
                            .font(.caption)
                            .foregroundColor(.secondary)

                    case .failure(let error):
                        Label("Apply 失敗", systemImage: "xmark.circle.fill")
                            .foregroundColor(.red)

                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            // MARK: - Undo Button
            if let result = applyResult,
               case .success(_, _, let rollback) = result,
               undoResult == nil {

                Divider()

                Button {
                    undo(rollback: rollback)
                } label: {
                    Text("元に戻す（Undo）")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            // MARK: - Undo Result
            if let undoResult {
                VStack(alignment: .leading, spacing: 8) {
                    switch undoResult {

                    case .success:
                        Label("Undo 成功", systemImage: "arrow.uturn.backward.circle.fill")
                            .foregroundColor(.green)

                    case .failure(let error):
                        Label("Undo 失敗", systemImage: "xmark.circle.fill")
                            .foregroundColor(.red)

                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Actions

    private func applyOne() {
        applyService.apply(plans: [plan]) { results in
            DispatchQueue.main.async {
                self.applyResult = results.first
            }
        }
    }

    private func undo(rollback: RollbackInfo) {
        undoService.undo(rollback: rollback) { result in
            DispatchQueue.main.async {
                self.undoResult = result
            }
        }
    }
}
