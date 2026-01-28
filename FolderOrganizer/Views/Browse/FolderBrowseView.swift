// FolderOrganizer/Views/Browse/FolderBrowseView.swift
//
// フォルダツリー表示（C-1 UI 最小実装）
// - OutlineGroup による階層表示
// - role（SERIES / VOLUME / UNKNOWN）バッジ表示
// - 確信度（★）を色付きで表示
// - ロジックは触らず View 側のみで完結
//

import SwiftUI

struct FolderBrowseView: View {

    let rootNode: FolderNode?

    var body: some View {
        Group {
            if let root = rootNode {
                List {
                    OutlineGroup([root], children: \.children) { node in
                        HStack(spacing: 8) {

                            Image(systemName: "folder")
                                .foregroundColor(.accentColor)

                            // フォルダ名
                            Text(node.name)
                                .lineLimit(1)

                            // role バッジ
                            Text(node.roleHint.rawValue)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(roleBackground(node.roleHint))
                                .foregroundColor(.white)
                                .cornerRadius(6)

                            // 確信度（★）
                            ConfidenceStarsView(confidence: node.confidence)

                            Spacer()

                            // ファイル数（任意情報）
                            if node.fileCount > 0 {
                                Text("(\(node.fileCount))")
                                    .font(.caption2)
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
    }

    // MARK: - UI Helpers

    private func roleBackground(_ role: FolderRoleHint) -> Color {
        switch role {
        case .series:
            return .blue
        case .volume:
            return .green
        case .unknown:
            return .gray
        }
    }
}

// MARK: - Confidence Stars

private struct ConfidenceStarsView: View {

    let confidence: FolderConfidence

    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<3, id: \.self) { index in
                Image(systemName: starSymbol(at: index))
                    .foregroundColor(starColor)
                    .font(.caption2)
            }
        }
    }

    private var filledCount: Int {
        switch confidence {
        case .high:
            return 3
        case .medium:
            return 2
        case .low:
            return 1
        }
    }

    private func starSymbol(at index: Int) -> String {
        index < filledCount ? "star.fill" : "star"
    }

    private var starColor: Color {
        switch confidence {
        case .high:
            return .green
        case .medium:
            return .yellow
        case .low:
            return .gray
        }
    }
}
