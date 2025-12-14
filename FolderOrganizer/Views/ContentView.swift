import SwiftUI
import AppKit

struct ContentView: View {

    @State private var selectedFolderURL: URL?
    @State private var itemURLs: [URL] = []
    @State private var showDryRun = false

    @StateObject private var decisionStore = UserDecisionStore()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Button {
                    selectFolder()
                } label: {
                    Text("フォルダを選択")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                if let folder = selectedFolderURL {
                    Text("選択中: \(folder.path)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                Button {
                    showDryRun = true
                } label: {
                    Text("Dry Run Preview を開く")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(itemURLs.isEmpty)

                Spacer()
            }
            .padding()
            .navigationTitle("Folder Organizer")
            .navigationDestination(isPresented: $showDryRun) {
                DryRunPreviewView(itemURLs: itemURLs, decisionStore: decisionStore)
            }
        }
    }

    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.title = "整理対象フォルダを選択"
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK {
            guard let url = panel.url else { return }
            selectedFolderURL = url
            loadItems(in: url)
        }
    }

    private func loadItems(in folderURL: URL) {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: folderURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else {
            itemURLs = []
            return
        }
        itemURLs = contents
    }
}
