import SwiftUI

struct SingleApplyResultView: View {

    let plan: RenamePlan

    @State private var applyResult: ApplyResult?
    @State private var undoResult: UndoResult?

    private let applyService = DefaultRenameApplyService()
    private let undoService = DefaultRenameUndoService()

    var body: some View {
        VStack(spacing: 16) {

            Text("1件だけ Apply（安全確認）")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                Text("Before")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(plan.originalName)

                Text("After")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(plan.targetParentFolder.lastPathComponent) / \(plan.targetName)")
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

                    if result.success {
                        Label(
                            "Apply 成功",
                            systemImage: "checkmark.circle.fill"
                        )
                        .foregroundColor(.green)
                    } else if let error = result.error {
                        Label(
                            error.localizedDescription,
                            systemImage: "xmark.circle.fill"
                        )
                        .foregroundColor(.red)
                    }

                    // MARK: - Undo Button

                    if result.success && undoResult == nil {
                        Button {
                            undo()
                        } label: {
                            Text("元に戻す（Undo）")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.orange)
                    }

                    if let undo = undoResult {
                        if undo.success {
                            Label(
                                "元に戻しました",
                                systemImage: "arrow.uturn.backward.circle.fill"
                            )
                            .foregroundColor(.blue)
                        } else if let error = undo.error {
                            Label(
                                error.localizedDescription,
                                systemImage: "xmark.circle.fill"
                            )
                            .foregroundColor(.red)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Actions

    private func applyOne() {
        applyResult = applyService.apply(plan)
    }

    private func undo() {
        guard let result = applyResult else { return }
        undoResult = undoService.undo(result)
    }
}
