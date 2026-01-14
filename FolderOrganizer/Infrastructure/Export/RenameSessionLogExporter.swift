// Infrastructure/Export/RenameSessionLogExporter.swift
//
// RenameSessionLog を JSON にエンコードし、ファイルとして保存する Exporter
//

import Foundation

final class RenameSessionLogExporter: RenameSessionLogExporting {

    private let exportService: RenameExportService
    private let directoryProvider: RenameSessionLogDirectoryProviding

    init(
        exportService: RenameExportService = DefaultRenameExportService(),
        directoryProvider: RenameSessionLogDirectoryProviding = DefaultRenameSessionLogDirectoryProvider()
    ) {
        self.exportService = exportService
        self.directoryProvider = directoryProvider
    }

    func export(log: RenameSessionLog) throws {
        let directory = try directoryProvider.exportDirectory()
        let fileURL = directory.appendingPathComponent(makeFileName())
        let data = try makeEncoder().encode(log)

        try exportService.export(data: data, to: fileURL)
    }

    // MARK: - Private

    private func makeFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        return "rename-session-\(formatter.string(from: Date())).json"
    }

    private func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
