// Services/FileScanService.swift
import Foundation
import AppKit

struct FileScanService {

    // MARK: - フォルダ選択ダイアログ

    static func pickFolder(completion: @escaping (URL?) -> Void) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = "選択"

        panel.begin { response in
            if response == .OK {
                completion(panel.urls.first)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: - 選択フォルダ直下の「フォルダ名一覧」を取得

    static func loadFolderNames(from url: URL) -> [String] {
        let fm = FileManager.default

        guard let contents = try? fm.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        let folderNames = contents
            .filter { $0.hasDirectoryPath }
            .map { $0.lastPathComponent }
            .sorted()

        return folderNames
    }
}
