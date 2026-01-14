// Infrastructure/Export/DefaultRenameExportService.swift
//
// Data を指定された URL に書き出す最下層 Export Service。
// RenamePlan / RenameSessionLog / JSON の存在は一切知らない。
//

import Foundation

final class DefaultRenameExportService: RenameExportService {

    // MARK: - Export

    func export(
        data: Data,
        to url: URL
    ) throws {
        try data.write(to: url, options: .atomic)
    }
}
