// Logic/RenamePlanEngine.swift
//
// フォルダ配下から RenamePlan 一覧を生成する
//

import Foundation

final class RenamePlanEngine {

    // MARK: - Dependencies

    private let fileScanService: FileScanService
    private let itemBuilder: RenameItemBuilder
    private let planBuilder: RenamePlanBuilder

    // MARK: - Init

    init(
        fileScanService: FileScanService = FileScanService(),
        itemBuilder: RenameItemBuilder = RenameItemBuilder(),
        planBuilder: RenamePlanBuilder = RenamePlanBuilder()
    ) {
        self.fileScanService = fileScanService
        self.itemBuilder = itemBuilder
        self.planBuilder = planBuilder
    }

    // MARK: - Public

    func buildPlans(from rootURL: URL) -> [RenamePlan] {

        // ✅ ScanResult を正しく受け取る
        let scanResult = fileScanService.scan(rootURL: rootURL)

        // v0.2 では errors は無視（後でログ化してもOK）
        let urls = scanResult.urls

        return urls.compactMap { url in
            guard let item = itemBuilder.buildRenameItem(from: url) else {
                return nil
            }

            return planBuilder.build(
                item: item,
                originalURL: url,
                targetParentURL: url.deletingLastPathComponent()
            )
        }
    }
}
