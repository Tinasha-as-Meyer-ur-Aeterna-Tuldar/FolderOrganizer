// FolderOrganizer/Views/Browse/FolderBrowseView.swift
//
// フォルダツリー表示ビュー
// - OutlineGroup で階層表示
// - 役割バッジ（SERIES / VOLUME / UNKNOWN）を表示
// - 確信度バッジ（★）を表示（C-1 UI 最小）
//

import SwiftUI

struct FolderBrowseView: View {

    let rootNode: FolderNode?

    var body: some View {
        Group {
            if let root = rootNode {
                List {
                    // OutlineGroup は children が Optional の KeyPath を要求するため、
                    // FolderNode.children は [FolderNode]? で持つ（nil = leaf）
                    OutlineGroup([root], children: \.children) { node in
                        row(for: node)
                    }
                }
                .listStyle(.inset)
            } else {
                Text("フォルダが選択されていません")
                    .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Row

    @ViewBuilder
    private func row(for node: FolderNode) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "folder")
                .foregroundColor(.accentColor)

            Text(node.name)
                .lineLimit(1)

            // 役割バッジ
            roleBadge(node.roleHint)

            // 確信度バッジ（最小）
            confidenceBadge(node.confidence)

            if node.fileCount > 0 {
                Text("(\(node.fileCount))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }

    // MARK: - Badges

    private func roleBadge(_ role: FolderRoleHint) -> some View {
        Text(role.rawValue)
            .font(.caption2)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(roleBadgeColor(role))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    private func roleBadgeColor(_ role: FolderRoleHint) -> Color {
        switch role {
        case .series:
            return .blue
        case .volume:
            return .green
        case .unknown:
            return .gray
        }
    }

    private func confidenceBadge(_ confidence: RoleConfidence) -> some View {
        Text(confidence.stars)
            .font(.caption2)
            .foregroundColor(confidence.color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.secondary.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
