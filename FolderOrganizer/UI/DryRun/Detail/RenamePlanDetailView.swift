import SwiftUI

struct RenamePlanDetailView: View {

    let originalURL: URL
    @ObservedObject var decisionStore: UserDecisionStore

    private let engine = RenamePlanEngine()

    @State private var plan: RenamePlan
    @State private var showDecisionSheet = false

    // 🔘 安全 Apply 用
    @State private var showSingleApply = false

    // 🎛 Diff 表示設定
    @AppStorage(DiffSettings.showDiffKey)
    private var showDiff: Bool = true

    init(
        plan: RenamePlan,
        decisionStore: UserDecisionStore
    ) {
        self.originalURL = plan.originalURL
        self._plan = State(initialValue: plan)
        self.decisionStore = decisionStore
    }

    var body: some View {
        Form {

            // MARK: - Rename（Before / After）

            Section("Rename") {
                LabeledContent("Before") {
                    Text(plan.originalName)
                }

                LabeledContent("After") {
                    Text("\(plan.targetParentFolder.lastPathComponent) / \(plan.targetName)")
                        .fontWeight(.semibold)
                }
            }

            // MARK: - Diff Preview

            Section("Diff Preview") {
                if showDiff {
                    DiffTextView(
                        segments: TextDiff.diff(
                            before: plan.originalName,
                            after: plan.targetName
                        )
                    )
                } else {
                    Text(plan.targetName)
                        .font(.body)
                        .fontWeight(.semibold)
                }
            }

            // MARK: - Detected Information

            Section("Detected Information") {

                LabeledContent("Author") {
                    Text(plan.detectedAuthor ?? "—")
                }

                LabeledContent("Title") {
                    Text(plan.title)
                }

                LabeledContent("Subtitle") {
                    Text(plan.subtitle ?? "—")
                }

                LabeledContent("Maybe Subtitle") {
                    if let maybe = plan.maybeSubtitle {
                        HStack {
                            Text(maybe)
                                .foregroundColor(.orange)
                            Spacer()
                            Button("判断する") {
                                showDecisionSheet = true
                            }
                        }
                    } else {
                        Text("—")
                            .foregroundColor(.secondary)
                    }
                }
            }

            // MARK: - Warnings

            if !plan.warnings.isEmpty {
                Section("Warnings") {
                    ForEach(plan.warnings) { warning in
                        Label(
                            warning.message,
                            systemImage: "exclamationmark.triangle.fill"
                        )
                        .foregroundColor(.orange)
                    }
                }
            }

            // MARK: - 🔘 Safe Apply（★ここが追加部分）

            Section {
                Button {
                    showSingleApply = true
                } label: {
                    Text("この1件だけ Apply（安全確認）")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(hasBlockingWarning)
            } footer: {
                if hasBlockingWarning {
                    Text("実行不可の警告があるため Apply できません")
                        .foregroundColor(.red)
                } else {
                    Text("この項目のみを実際にリネームし、結果を確認できます")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Rename Detail")

        // maybe subtitle 判断 Sheet
        .sheet(isPresented: $showDecisionSheet) {
            MaybeSubtitleDecisionView(
                plan: plan,
                decisionStore: decisionStore
            )
            .presentationDetents([.medium])
        }

        // 🔘 安全 Apply Sheet
        .sheet(isPresented: $showSingleApply) {
            SingleApplyResultView(plan: plan)
                .presentationDetents([.large])
        }

        // 🔄 判断変更 → 再 DryRun
        .onChange(of: decisionStore.decision(for: originalURL)) { _ in
            regeneratePlan()
        }
    }

    // MARK: - Helpers

    private var hasBlockingWarning: Bool {
        plan.warnings.contains {
            if case .authorNotDetected = $0 { return true }
            return false
        }
    }

    private func regeneratePlan() {
        let decision = decisionStore.decision(for: originalURL)
        plan = engine.generatePlan(
            for: originalURL,
            userDecision: decision
        )
    }
}
