import SwiftUI

struct ApplyExecutionView: View {

    let plans: [RenamePlan]

    @State private var results: [ApplyResult] = []
    @State private var undoResults: [UndoResult] = []
    @State private var executed = false
    @State private var undone = false

    private let applyService = DefaultRenameApplyService()
    private let undoService = DefaultRenameUndoService()

    var body: some View {
        List {

            if !executed {
                Button {
                    execute()
                } label: {
                    Text("Execute Apply")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }

            if executed && !undone {
                Button {
                    undo()
                } label: {
                    Text("Undo All")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .foregroundColor(.orange)
            }

            Section("Apply Results") {
                ForEach(results) { result in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(result.plan.originalName)

                        if result.success {
                            Label("Applied", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else if let error = result.error {
                            Label(error.localizedDescription,
                                  systemImage: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            if undone {
                Section("Undo Results") {
                    ForEach(undoResults) { result in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(result.applyResult.plan.originalName)

                            if result.success {
                                Label("Restored",
                                      systemImage: "arrow.uturn.backward.circle.fill")
                                    .foregroundColor(.blue)
                            } else if let error = result.error {
                                Label(error.localizedDescription,
                                      systemImage: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Apply Result")
    }

    private func execute() {
        results = plans.map {
            applyService.apply($0)
        }
        executed = true
    }

    private func undo() {
        undoResults = results.map {
            undoService.undo($0)
        }
        undone = true
    }
}
