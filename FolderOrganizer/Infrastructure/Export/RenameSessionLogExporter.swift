// Infrastructure/Export/RenameSessionLogExporter.swift
//
// RenameSessionLog を JSON として保存する Exporter
// - 保存先：~/Documents/FolderOrganizer/Logs/
// - 1 Apply = 1 JSON ファイル
// - prettyPrinted + sortedKeys（差分が見やすい）
// - Date は ISO8601 で出力
//

import Foundation

protocol RenameSessionLogExporting {
    /// 保存した JSON の URL を返す
    func export(log: RenameSessionLog) throws -> URL
}

final class RenameSessionLogExporter: RenameSessionLogExporting {

    // MARK: - Dependencies

    private let fileManager: FileManager
    private let encoder: JSONEncoder

    // MARK: - Init

    init(
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]

        // ISO8601 で統一（人間も読める / 将来の互換性が高い）
        if #available(macOS 12.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        } else {
            // macOS 11 向けフォールバック（最低限）
            let formatter = ISO8601DateFormatter()
            encoder.dateEncodingStrategy = .custom { date, enc in
                var container = enc.singleValueContainer()
                try container.encode(formatter.string(from: date))
            }
        }

        self.encoder = encoder
    }

    // MARK: - Public

    func export(log: RenameSessionLog) throws -> URL {
        let dirURL = try ensureLogsDirectory()

        let fileURL = dirURL.appendingPathComponent(makeFileName(for: log.createdAt))

        let data = try encoder.encode(log)
        try data.write(to: fileURL, options: [.atomic])

        return fileURL
    }

    // MARK: - Directory

    private func ensureLogsDirectory() throws -> URL {
        guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw ExportError.failedToResolveDocumentsDirectory
        }

        let dir = documents
            .appendingPathComponent("FolderOrganizer", isDirectory: true)
            .appendingPathComponent("Logs", isDirectory: true)

        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: dir.path, isDirectory: &isDir) {
            if isDir.boolValue { return dir }
            throw ExportError.logsPathIsNotDirectory(dir)
        }

        do {
            try fileManager.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
            return dir
        } catch {
            throw ExportError.failedToCreateLogsDirectory(dir, underlying: error)
        }
    }

    // MARK: - Naming

    private func makeFileName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"

        return "\(formatter.string(from: date))_Apply.json"
    }

    // MARK: - Error

    enum ExportError: LocalizedError {
        case failedToResolveDocumentsDirectory
        case logsPathIsNotDirectory(URL)
        case failedToCreateLogsDirectory(URL, underlying: Error)

        var errorDescription: String? {
            switch self {
            case .failedToResolveDocumentsDirectory:
                return "Documents ディレクトリの取得に失敗しました。"
            case .logsPathIsNotDirectory(let url):
                return "Logs 保存先がディレクトリではありません: \(url.path)"
            case .failedToCreateLogsDirectory(let url, let underlying):
                return "Logs 保存先の作成に失敗しました: \(url.path) (\(underlying.localizedDescription))"
            }
        }
    }
}
