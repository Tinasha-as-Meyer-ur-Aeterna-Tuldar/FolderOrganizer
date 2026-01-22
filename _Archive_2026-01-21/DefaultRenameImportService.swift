//
//  DefaultRenameImportService.swift
//  FolderOrganizer
//

import Foundation

final class DefaultRenameImportService: RenameImportService {

    private let decoder: JSONDecoder

    init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    func `import`(data: Data) throws -> RenameImportResult {

        let document: RenameExportDocument
        do {
            document = try decoder.decode(RenameExportDocument.self, from: data)
        } catch {
            throw RenameImportError.decodeFailed(error)
        }

        // Version check
        guard document.version == .v1 else {
            throw RenameImportError.unsupportedVersion
        }

        let rootFolderURL = URL(fileURLWithPath: document.rootFolderPath)

        let plans: [RenamePlan] = document.items.map { export in
            export.toDomain()
        }

        return RenameImportResult(
            rootFolderURL: rootFolderURL,
            plans: plans
        )
    }
}
