//
//  RenameSession.swift
//  FolderOrganizer
//

import Foundation

/// 一覧表示 + 編集オーバーレイを持つセッション（UI状態も含む）
final class RenameSession: ObservableObject {

    // MARK: - Data
    @Published var items: [RenameItem]

    // MARK: - Selection
    @Published var selectedID: RenameItem.ID?

    // MARK: - Editing
    @Published var isEditing: Bool = false
    @Published var editingText: String = ""

    init(items: [RenameItem]) {
        self.items = items
        self.selectedID = items.first?.id
    }

    // MARK: - Helpers
    private var selectedIndex: Int? {
        guard let id = selectedID else { return nil }
        return items.firstIndex(where: { $0.id == id })
    }

    // MARK: - Actions
    func startEditing() {
        guard let idx = selectedIndex else { return }
        editingText = items[idx].normalized
        isEditing = true
    }

    func finishEditing() {
        guard let idx = selectedIndex else { return }
        items[idx].normalized = editingText
        isEditing = false
    }

    func cancelEditing() {
        isEditing = false
    }
}
