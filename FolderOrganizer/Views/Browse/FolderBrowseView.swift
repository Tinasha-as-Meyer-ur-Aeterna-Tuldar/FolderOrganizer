// FolderOrganizer/Views/Browse/FolderBrowseView.swift
//
// フォルダ選択 → RenameItem（＋正規化名）一覧表示
// ・v0.2 の「実データ確認」＋「URL→RenameItem 変換」まで
// ・Plan / Diff / Edit / Apply は未実装
//

import SwiftUI

struct FolderBrowseView: View {

    // MARK: - State

    @State private var selectedFolderURL: URL?
    @State private var items: [RenameItemBuilder.Built] = []
    @State private var errorMessage: String?

    private let scanService = FileScanService()
    private let itemBuilder = RenameItemBuilder()

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(spacing: 10) {
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
                List(items) { built in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(built.item.original)

                        Text(built.normalizedName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
    }

    // MARK: - Private

    private func openFolder() {
        let panel = NSOpenPanel()
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
            let urls = try scanService.scan(folderURL: url)
            items = urls.compactMap { itemBuilder.build(from: $0) }
            errorMessage = nil
        } catch {
            items = []
            errorMessage = error.localizedDescription
        }
    }
}
