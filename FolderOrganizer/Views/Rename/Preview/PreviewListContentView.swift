//
//  PreviewListContentView.swift
//  FolderOrganizer
//
//  プレビュー一覧（常時表示）
//  編集オーバーレイは ZStack で上に重ねる（STEP C）
//

import SwiftUI

struct PreviewListContentView: View {

    // MARK: - Session
    @ObservedObject var session: RenameSession

    // MARK: - 表示オプション
    let showSpaceMarkers: Bool

    /// Diff 表示 ON / OFF（STEP D でトグル化予定）
    private let isDiffVisible: Bool = true

    // MARK: - Body
    var body: some View {
        ZStack {

            // =========================
            // 一覧（常に表示）
            // =========================
            List(selection: $session.selectedID) {
                ForEach(session.items) { item in
                    RenamePreviewRowView(
                        item: item,
                        isDiffVisible: isDiffVisible,
                        onEdit: {
                            // View 更新中の状態変更を避ける
                            DispatchQueue.main.async {
                                session.selectedID = item.id
                                session.startEditing()
                            }
                        }
                    )
                    .tag(item.id)
                    .listRowBackground(rowBackground(for: item))
                }
            }
            .listStyle(.plain)

            // =========================
            // 編集オーバーレイ（STEP C）
            // =========================
            if session.isEditing {
                RenameEditView(session: session)
            }
        }
    }

    // MARK: - Row Background
    private func rowBackground(for item: RenameItem) -> Color {
        session.selectedID == item.id
            ? Color.accentColor.opacity(0.15)
            : Color.clear
    }
}
