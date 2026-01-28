// FolderOrganizer/Views/Browse/FolderBrowseView.swift
//
// フォルダ選択と、その配下の一覧表示を行う View
// ・v0.2 最初の「現実確認」用
// ・RenamePlan / Diff / Apply には一切触れない
//

import SwiftUI

struct FolderBrowseView: View {

    // MARK: - State

    @State private var selectedFolderURL: URL?
    @State private var items: [URL] = []
    @State private var errorMessage: String?

    private let scanService = FileScanService()

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Button("フォルダを選択") {
                    openFolder()
                }

                if let folderURL = selectedFolderURL {
                    Text(folderURL.path)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Divider()

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            if items.isEmpty {
                Text("フォルダが選択されていません")
                    .foregroundColor(.secondary)
            } else {
                List(items, id: \.self) { url in
                    HStack {
                        Image(systemName: "doc")
                        Text(url.lastPathComponent)
                            .font(.system(size: 13))
                    }
                }
            }
        }
        .padding()
    }

    // MARK: - Private

    private func openFolder() {
        let panel = NSOpenPanel()
        panel.title = "フォルダを選択"
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK {
            guard let url = panel.url else { return }
            selectedFolderURL = url
            loadFolder(url)
        }
    }

    private func loadFolder(_ url: URL) {
        do {
            items = try scanService.scan(folderURL: url)
            errorMessage = nil
        } catch {
            items = []
            errorMessage = error.localizedDescription
        }
    }
}
