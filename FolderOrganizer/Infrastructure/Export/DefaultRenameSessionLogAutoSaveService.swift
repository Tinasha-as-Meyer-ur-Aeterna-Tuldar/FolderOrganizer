// Infrastructure/Export/DefaultRenameSessionLogAutoSaveService.swift
//
// Apply 完了時に JSON を自動保存するための薄いサービス
// - 「どこで呼ぶか」は ViewModel / UseCase 側に依存するため、ここは純粋に処理をまとめる
// - v0.2-1 は Apply のみ。Undo ログは v0.2-2 以降で拡張
//

import Foundation

final class DefaultRenameSessionLogAutoSaveService {

    // MARK: - Dependencies

    private let builder: RenameSessionLogBuilding
    private let exporter: RenameSessionLogExporting

    // MARK: - Init

    init(
        builder: RenameSessionLogBuilding = RenameSessionLogBuilder(),
        exporter: RenameSessionLogExporting = RenameSessionLogExporter()
    ) {
        self.builder = builder
        self.exporter = exporter
    }

    // MARK: - Public

    /// Apply 完了時に呼ぶ（自動保存）
    /// - Note: UI スレッドで呼ばれても I/O を別スレッドに逃がす
    func saveAfterApply(
        rootURL: URL,
        plans: [RenamePlan],
        results: [ApplyResult]
    ) {
        DispatchQueue.global(qos: .utility).async {
            let log = self.builder.build(rootURL: rootURL, plans: plans, results: results)

            do {
                _ = try self.exporter.export(log: log)
            } catch {
                // v0.2-1：自動保存は「失敗しても Apply 自体を失敗にしない」
                // 将来：通知・UI 表示・リトライなどを追加できるようにここで握りつぶす
                // print("AutoSave failed: \(error)")
            }
        }
    }
}
