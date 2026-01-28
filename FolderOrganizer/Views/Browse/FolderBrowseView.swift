// FolderOrganizer/Views/Browse/FolderBrowseView.swift
//
// フォルダ選択 → ツリー表示（構造可視化）
// ・macOS 向けに List + OutlineGroup を使用
// ・構造を「見る」ためのフェーズ
//

import SwiftUI

struct FolderBrowseView: View {

    // MARK: - State

    @State private var selectedFolderURL: URL?
    @State private var rootNode: FolderNode?
    @State private var errorMessage: String?

    private let treeBuilder = FolderTreeBuilder()

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // フォルダ選択
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

            // ★ ここが重要
            if let root = rootNode {
                List {
                    OutlineGroup(root, children: \.childrenForOutline) { node in
                        HStack(spacing: 8) {
                            Image(systemName: "folder")
                                .foregroundColor(.accentColor)

                            Text(node.name)

                            if node.fileCount > 0 {
                                Text("(\(node.fileCount))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 2) // 行の押しやすさ改善
                    }
                }
                .listStyle(.inset) // macOS向けに自然
            } else {
                Text("フォルダが選択されていません")
                    .foregroundColor(.secondary)
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
            loadTree(url)
        }
    }

    private func loadTree(_ url: URL) {
        rootNode = treeBuilder.buildTree(from: url)
        errorMessage = nil
    }
}
