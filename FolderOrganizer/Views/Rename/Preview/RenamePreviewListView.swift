//
// Views/Rename/Preview/RenamePreviewListView.swift
// Preview 一覧本体（Session を監視）
// ・初期フォーカス
// ・↑↓ 移動
// ・Enter で編集開始
//

import SwiftUI

struct RenamePreviewListView: View {

    @ObservedObject var session: RenameSession
    let showSpaceMarkers: Bool

    @FocusState private var isListFocused: Bool

    var body: some View {
        ScrollViewReader { proxy in
            List(selection: $session.selectedID) {

                ForEach(session.items) { item in
                    RenamePreviewRowView(
                        item: item,
                        showSpaceMarkers: showSpaceMarkers,
                        onEdit: {
                            startEditing(item.id)
                        }
                    )
                    .tag(item.id)
                    .id(item.id)
                    .listRowBackground(
                        session.selectedID == item.id
                        ? Color.accentColor.opacity(0.15)
                        : Color.clear
                    )
                }
            }
            // フォーカス対象
            .focused($isListFocused)

            // 起動直後にフォーカス & 初期選択
            .onAppear {
                DispatchQueue.main.async {
                    isListFocused = true
                    if session.selectedID == nil {
                        session.selectedID = session.items.first?.id
                    }
                }
            }

            // 選択変更で自動スクロール
            .onChange(of: session.selectedID) { _, newID in
                guard let newID else { return }
                withAnimation {
                    proxy.scrollTo(newID, anchor: .center)
                }
            }

            // ⏎ Enter キー（macOS 14+）
            .onKeyPress(.return) {
                guard let id = session.selectedID else { return .ignored }
                startEditing(id)
                return .handled
            }

            // 編集画面
            .sheet(isPresented: $session.isEditing) {
                RenameEditView(
                    session: session,
                    showSpaceMarkers: showSpaceMarkers
                )
            }
        }
    }

    // MARK: - Editing

    private func startEditing(_ id: RenameItem.ID) {
        session.selectedID = id
        session.isEditing = true
    }
}
