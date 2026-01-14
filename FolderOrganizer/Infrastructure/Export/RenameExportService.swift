// Infrastructure/Export/RenameExportService.swift
//

import Foundation

protocol RenameExportService {

    /// Data を指定 URL に書き出す
    func export(
        data: Data,
        to url: URL
    ) throws
}
