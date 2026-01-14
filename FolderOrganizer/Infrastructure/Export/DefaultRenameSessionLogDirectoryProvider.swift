// Infrastructure/Export/DefaultRenameSessionLogDirectoryProvider.swift
//

import Foundation

final class DefaultRenameSessionLogDirectoryProvider: RenameSessionLogDirectoryProviding {

    func exportDirectory() throws -> URL {
        let base = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!

        let directory = base
            .appendingPathComponent("FolderOrganizer", isDirectory: true)
            .appendingPathComponent("Exports", isDirectory: true)

        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )

        return directory
    }
}
