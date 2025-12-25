//
// Views/Rename/Preview/RenamePreviewListView.swift
// Preview 一覧本体（Session を監視 + キーボード操作）
//

import SwiftUI

struct RenamePreviewListView: View {

    @ObservedObject var session: RenameSession
    let showSpaceMarkers: Bool

    var body: some View {
        ScrollViewReader { proxy in
            List(selection: $session.selectedID) {

                ForEach(session.items) { item in
                    RenamePreviewRowView(
                        item: item,
                        showSpaceMarkers: showSpaceMarkers,
                        isDiffVisible: session.isDiffVisible,
                        onEdit: {
                            session.selectedID = item.id
                            session.isEditing = true
                        }
                    )
                    .tag(item.id)          // ← List(selection:) 用
                    .id(item.id)           // ← scrollTo 用
                    .listRowBackground(
                        session.selectedID == item.id
                        ? Color.accentColor.opacity(0.15)
                        : Color.clear
                    )
                }
            }
            .listStyle(.plain)

            // 初期フォーカス（最初の1件）
            .onAppear {
                if session.selectedID == nil {
                    session.selectedID = session.items.first?.id
                }
            }

            // 選択変更時に自動スクロール
            .onChange(of: session.selectedID) { _, newID in
                guard let newID else { return }
                withAnimation {
                    proxy.scrollTo(newID, anchor: .center)
                }
            }

            // =========================
            // キーボード操作
            // =========================

            // Space / Shift + Space
            // ※ ここで phases: を付けないと「0引数クロージャ版」が選ばれてコンパイルエラーになる
            .onKeyPress(.space, phases: [.down]) { keyPress in
                if keyPress.modifiers.contains(.shift) {
                    // Shift + Space → Diff 表示 ON / OFF
                    session.toggleDiffVisibility()
                } else {
                    // Space → flagged 切替
                    session.toggleFlagForSelectedItem()
                }
                return .handled
            }

            // Enter → 編集開始
            .onKeyPress(.return, phases: [.down]) { _ in
                session.startEditing()
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
}
