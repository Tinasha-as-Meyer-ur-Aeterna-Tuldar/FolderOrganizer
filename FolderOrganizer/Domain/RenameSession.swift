//
// Domain/RenameSession.swift
// 一覧・編集で共有するセッション（唯一の状態源）
// Diff 表示トグル追加
//

import Foundation
import SwiftUI

@MainActor
final class RenameSession: ObservableObject {

    // 一覧に表示される全アイテム
    @Published var items: [RenameItem]

    // 現在選択中のアイテムID
    @Published var selectedID: RenameItem.ID? = nil

    // 編集シート表示中か
    @Published var isEditing: Bool = false

    // Diff 表示 ON / OFF（一覧全体）
    @Published var isDiffVisible: Bool = true

    init(items: [RenameItem]) {
        self.items = items
    }

    // MARK: - Derived

    var selectedIndex: Int? {
        guard let id = selectedID else { return nil }
        return items.firstIndex { $0.id == id }
    }

    // MARK: - Selection Control

    func moveSelection(_ delta: Int) {
        guard let index = selectedIndex else { return }
        let newIndex = index + delta
        guard items.indices.contains(newIndex) else { return }
        selectedID = items[newIndex].id
    }

    // MARK: - Flag Control

    func toggleFlagForSelectedItem() {
        guard let index = selectedIndex else { return }
        items[index].flagged.toggle()
    }

    // MARK: - Diff Control

    /// Diff 表示をトグル（一覧用）
    func toggleDiffVisibility() {
        isDiffVisible.toggle()
    }

    // MARK: - Editing Control

    func startEditing() {
        guard selectedID != nil else { return }
        isEditing = true
    }

    func closeEditing() {
        isEditing = false
    }
}
