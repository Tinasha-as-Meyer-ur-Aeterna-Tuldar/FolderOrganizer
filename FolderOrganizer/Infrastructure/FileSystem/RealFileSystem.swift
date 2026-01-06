//
//  RealFileSystem.swift
//  FolderOrganizer
//

import Foundation

final class RealFileSystem: FileSystem {

    private let fm = FileManager.default

    func fileExists(at url: URL) -> Bool {
        fm.fileExists(atPath: url.path)
    }

    func createDirectory(at url: URL) throws {
        try fm.createDirectory(at: url, withIntermediateDirectories: true)
    }

    func moveItem(from: URL, to: URL) throws {
        try fm.moveItem(at: from, to: to)
    }
}
