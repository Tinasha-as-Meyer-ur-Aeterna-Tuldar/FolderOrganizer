// Infrastructure/Export/DefaultRenameSessionLogAutoSaveService.swift
//
// Apply 完了時に RenameSessionLog を自動保存する Service
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

    func saveAfterApply(
        rootURL: URL,
        plans: [RenamePlan],
        results: [ApplyResult],
        rollbackInfo: RollbackInfo?
    ) {
        DispatchQueue.global(qos: .utility).async {
            let log = self.builder.build(
                rootURL: rootURL,
                plans: plans,
                applyResults: results,
                rollbackInfo: rollbackInfo
            )

            do {
                try self.exporter.export(log: log)
            } catch {
                // v0.2 方針：
                // AutoSave の失敗は Apply を失敗させない
                print("AutoSave failed: \(error)")
            }
        }
    }
}
