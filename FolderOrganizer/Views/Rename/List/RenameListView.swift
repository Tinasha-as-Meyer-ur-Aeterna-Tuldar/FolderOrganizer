//
// Views/Rename/List/RenameListView.swift
// Rename 一覧（Session 管理 / selection + scroll + sheet）
//

import SwiftUI

struct RenameListView: View {

    @StateObject private var session = RenameSession(
        items: FileScanService.loadSampleNames()
    )

    let showSpaceMarkers: Bool

    var body: some View {
        ScrollViewReader { proxy in
            List(selection: $session.selectedID) {

                ForEach(session.items) { item in
                    row(for: item)
                }
            }

            // 選択変更 → 自動で中央へスクロール
            .onChange(of: session.selectedID) { _, newID in
                guard let newID else { return }
                withAnimation {
                    proxy.scrollTo(newID, anchor: .center)
                }
            }

            // 編集画面（Enter で session.isEditing = true になれば開く）
            .sheet(isPresented: $session.isEditing) {
                RenameEditView(
                    session: session,
                    showSpaceMarkers: showSpaceMarkers
                )
            }
        }
    }

    // MARK: - Row（型推論分離）

    @ViewBuilder
    private func row(for item: RenameItem) -> some View {

        // ★ここで必要な引数 isDiffVisible を渡す
        RenamePreviewRowView(
            item: item,
            showSpaceMarkers: showSpaceMarkers,
            isDiffVisible: session.isDiffVisible,
            onEdit: {
                session.selectedID = item.id
                session.isEditing = true
            }
        )
        .tag(item.id) // List(selection:) 用
        .id(item.id)  // scrollTo 用
        .listRowBackground(
            session.selectedID == item.id
            ? Color.accentColor.opacity(0.15)
            : Color.clear
        )
    }
}
