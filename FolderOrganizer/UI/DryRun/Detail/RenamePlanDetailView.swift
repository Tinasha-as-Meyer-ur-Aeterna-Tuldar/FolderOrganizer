import SwiftUI

struct RenamePlanDetailView: View {

    let originalURL: URL
    @ObservedObject var decisionStore: UserDecisionStore

    private let engine = RenamePlanEngine()

    @State private var plan: RenamePlan
    @State private var showDecisionSheet = false
    @State private var showSingleApply = false

    @AppStorage(DiffSettings.showDiffKey)
    private var showDiff: Bool = true

    init(plan: RenamePlan, decisionStore: UserDecisionStore) {
        self.originalURL = plan.originalURL
        self._plan = State(initialValue: plan)
        self.decisionStore = decisionStore
    }

    var body: some View {
        Form {

            // MARK: - Rename
            Section("Rename") {
                LabeledContent("Before") {
                    Text(plan.originalName)
                }
                LabeledContent("After") {
                    Text("\(plan.targetParentFolder.lastPathComponent) / \(plan.targetName)")
                        .fontWeight(.semibold)
                }
            }

            // MARK: - Diff
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

            // MARK: - Detected Info
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
                            Text(maybe).foregroundColor(.orange)
                            Spacer()
                            Button("判断する") {
                                showDecisionSheet = true
                            }
                        }
                    } else {
                        Text("—").foregroundColor(.secondary)
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

                    // 🔑 author 未検出のみ、解除ボタンを出す
                    if hasAuthorNotDetected {
                        Button {
                            decisionStore.setAuthorDecision(
                                .allowWithoutAuthor,
                                for: originalURL
                            )
                        } label: {
                            Text("作者不明のまま続行する")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }

            // MARK: - Safe Apply
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

        // MARK: - Sheets
        .sheet(isPresented: $showDecisionSheet) {
            MaybeSubtitleDecisionView(
                plan: plan,
                decisionStore: decisionStore
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showSingleApply) {
            SingleApplyResultView(plan: plan)
                .presentationDetents([.large])
        }

        // MARK: - Decision Change
        .onChange(
            of: decisionStore.decision(for: originalURL)
        ) { (_: UserSubtitleDecision) in
            regeneratePlan()
        }
        .onChange(
            of: decisionStore.authorDecision(for: originalURL)
        ) { (_: UserAuthorDecision) in
            regeneratePlan()
        }
    }

    // MARK: - Helpers

    private var hasAuthorNotDetected: Bool {
        plan.warnings.contains {
            if case .authorNotDetected = $0 { return true }
            return false
        }
    }

    private var hasBlockingWarning: Bool {
        hasAuthorNotDetected
    }

    private func regeneratePlan() {
        let subtitleDecision = decisionStore.decision(for: originalURL)

        var newPlan = engine.generatePlan(
            for: originalURL,
            userDecision: subtitleDecision
        )

        // 🔑 author 許可済みなら blocking を解除
        if decisionStore.authorDecision(for: originalURL) == .allowWithoutAuthor {
            newPlan = newPlan.allowingWithoutAuthor()
        }

        plan = newPlan
    }
}
