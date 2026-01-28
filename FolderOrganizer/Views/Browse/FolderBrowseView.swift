// FolderOrganizer/Views/Browse/FolderBrowseView.swift
//
// フォルダ選択 → ツリー表示（OutlineGroup）
// - STEP A: ツリーを “見る”
// - STEP B: roleHint（表示のみ）
//

import SwiftUI

struct FolderBrowseView: View {

    @State private var selectedFolderURL: URL?
    @State private var rootNode: FolderNode?
    @State private var errorMessage: String?

    private let treeBuilder = FolderTreeBuilder()

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Header
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

            // Tree
            if let root = rootNode {
                List {
                    OutlineGroup([root], children: \.childrenForOutline) { node in
                        HStack(spacing: 8) {
                            Image(systemName: "folder")
                                .foregroundColor(.accentColor)

                            Text(node.name)

                            roleBadge(node.roleHint)

                            if node.fileCount > 0 {
                                Text("(\(node.fileCount))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                .listStyle(.inset)
            } else {
                Text("フォルダが選択されていません")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)    }

    // MARK: - Role Badge

    private func roleBadge(_ role: FolderRoleHint) -> some View {
        Text(role.displayName)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(roleColor(role).opacity(0.15))
            .foregroundColor(roleColor(role))
            .cornerRadius(4)
    }

    private func roleColor(_ role: FolderRoleHint) -> Color {
        switch role {
        case .unknown:
            return .secondary
        case .series:
            return .blue
        case .volume:
            return .green
        }
    }

    // MARK: - Folder Picker

    private func openFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            selectedFolderURL = url
            loadTree(from: url)
        }
    }

    // MARK: - Load

    private func loadTree(from url: URL) {
        do {
            errorMessage = nil
            rootNode = try treeBuilder.buildTree(from: url)
        } catch {
            rootNode = nil
            errorMessage = "読み込みに失敗しました: \(error.localizedDescription)"
        }
    }
}
