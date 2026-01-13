//
//  Logic/FileSystemExistingNamesProvider.swift
//  FolderOrganizer
//
//  実ファイルシステムを使った既存名チェック
//

import Foundation

struct FileSystemExistingNamesProvider: ExistingNamesProvider {
    
    let folderURL: URL
    
    func exists(name: String) -> Bool {
        let targetURL = folderURL.appendingPathComponent(name)
        return FileManager.default.fileExists(atPath: targetURL.path)
    }
}
