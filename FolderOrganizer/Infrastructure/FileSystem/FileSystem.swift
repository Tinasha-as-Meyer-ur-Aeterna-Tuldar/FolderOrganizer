//
//  FileSystem.swift
//  FolderOrganizer
//

import Foundation

protocol FileSystem {
    func fileExists(at url: URL) -> Bool
    func createDirectory(at url: URL) throws
    func moveItem(from: URL, to: URL) throws
}
