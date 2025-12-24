//
// Views/Rename/Edit/RenameEditView.swift
// 編集ビュー（キーボード操作完全対応）
//

import SwiftUI

struct RenameEditView: View {

    @ObservedObject var session: RenameSession
    let showSpaceMarkers: Bool

    @FocusState private var isListFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            header

            List(selection: $session.selectedID) {
                ForEach(session.items) { item in
                    Text(item.original)
                        .tag(item.id)
                        .listRowBackground(
                            session.selectedID == item.id
                            ? Color.accentColor.opacity(0.20)
                            : Color.clear
                        )
                }
            }
            .focused($isListFocused)
            .onAppear {
                DispatchQueue.main.async {
                    isListFocused = true
                }
            }
        }
        .frame(minWidth: 420, minHeight: 320)
        // Esc で閉じる
        .keyboardShortcut(.escape, modifiers: [])
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button("↑") { session.moveSelection(-1) }
                .disabled(!(session.selectedIndex ?? 0 > 0))

            Button("↓") { session.moveSelection(1) }
                .disabled(!canMoveDown)

            Spacer()

            Text(positionText)
                .foregroundColor(.secondary)

            Button("閉じる") {
                session.isEditing = false
            }
        }
        .padding()
    }

    private var canMoveDown: Bool {
        guard let idx = session.selectedIndex else { return false }
        return idx < session.items.count - 1
    }

    private var positionText: String {
        guard let idx = session.selectedIndex else { return "-/-" }
        return "\(idx + 1)/\(session.items.count)"
    }
}
