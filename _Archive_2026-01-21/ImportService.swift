import Foundation

final class ImportService {

    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = ImportService.makeDecoder()) {
        self.decoder = decoder
    }

    // MARK: - Decoder

    private static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    // MARK: - RenamePlan（再 DryRun）

    func importRenamePlans(
        from url: URL
    ) throws -> [URL] {

        guard FileManager.default.fileExists(atPath: url.path) else {
            throw ImportError.fileNotFound(url)
        }

        let data = try Data(contentsOf: url)

        let imports = try decoder.decode(
            [RenamePlanImport].self,
            from: data
        )

        guard imports.allSatisfy({ $0.version == .v1 }) else {
            throw ImportError.unsupportedVersion("unknown")
        }

        // 元の URL だけ返す
        // → 再 DryRun は RenamePlanEngine に任せる
        return imports.map {
            URL(fileURLWithPath: $0.originalPath)
        }
    }

    // MARK: - ApplyResult（再 Apply）

    func importApplyResults(
        from url: URL
    ) throws -> [ApplyResultImport] {

        guard FileManager.default.fileExists(atPath: url.path) else {
            throw ImportError.fileNotFound(url)
        }

        let data = try Data(contentsOf: url)

        let imports = try decoder.decode(
            [ApplyResultImport].self,
            from: data
        )

        guard imports.allSatisfy({ $0.version == .v1 }) else {
            throw ImportError.unsupportedVersion("unknown")
        }

        return imports
    }
}
