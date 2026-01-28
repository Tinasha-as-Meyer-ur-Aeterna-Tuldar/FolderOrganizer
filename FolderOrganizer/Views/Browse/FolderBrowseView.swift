// FolderOrganizer/Views/Browse/FolderBrowseView.swift
//
// フォルダ選択 → RenameItem 一覧表示（Issue 可視化対応）
// ・RenameIssue を色＋アイコンで表示
// ・編集 / Diff / Apply は未実装
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
                        .foregroundColor(AppTheme.colors.secondaryText)
                        .lineLimit(1)
                }
            }

            Divider()

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(AppTheme.colors.issueError)
            }

            if items.isEmpty {
                Text("フォルダが選択されていません")
                    .foregroundColor(AppTheme.colors.secondaryText)
            } else {
                List(items) { built in
                    HStack(alignment: .top, spacing: 8) {

                        IssueIndicatorView(issues: built.item.issues)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(built.item.original)
                                .foregroundColor(AppTheme.colors.primaryText)

                            Text(built.normalizedName)
                                .font(.caption)
                                .foregroundColor(AppTheme.colors.secondaryText)
                        }
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
