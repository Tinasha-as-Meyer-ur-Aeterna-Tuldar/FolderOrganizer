import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {

    @State private var selectedFolderURL: URL?
    @State private var renamePlans: [RenamePlan] = []
    @State private var showDryRun = false

    private let engine = RenamePlanEngine()

    var body: some View {
        NavigationStack {

            VStack(spacing: 20) {

                // フォルダ選択
                Button {
                    selectFolder()
                } label: {
                    Text("フォルダを選択")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                // 選択フォルダ表示
                if let folder = selectedFolderURL {
                    Text("選択中: \(folder.lastPathComponent)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // DryRun 実行
                if !renamePlans.isEmpty {
                    Button {
                        showDryRun = true
                    } label: {
                        Text("Dry Run を実行")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Folder Organizer")
            .navigationDestination(isPresented: $showDryRun) {
                DryRunPreviewView(plans: renamePlans)
            }
        }
    }

    // MARK: - Folder Selection

    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.title = "整理対象フォルダを選択"
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK {
            guard let url = panel.url else { return }
            selectedFolderURL = url
            runDryRun(for: url)
        }
    }

    // MARK: - DryRun

    private func runDryRun(for folderURL: URL) {

        renamePlans.removeAll()

        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: folderURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else {
            return
        }

        renamePlans = contents.map {
            engine.generatePlan(for: $0)
        }
    }
}
