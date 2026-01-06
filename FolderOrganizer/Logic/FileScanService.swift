//
//  FileScanService.swift
//  FolderOrganizer
//

import Foundation

struct FileScanService {

    // MARK: - Sample（動作確認用）
    static func loadSampleNames() -> [RenameItem] {
        let samples: [String] = [
            "【あおぞら】",
            "[成年コミック] 猫夜 あげちん〜美女たちにSEXしてかれて〜 [DL版]"
        ]

        return samples.map { original in
            let normalizedResult = NameNormalizer.normalize(original)
            let normalized = normalizedResult.value

            return RenameItem(
                original: original,
                normalized: normalized,
                flagged: false
            )
        }
    }

    // MARK: - Scan（直下フォルダのみ）
    static func scanFolders(in rootFolderURL: URL) throws -> [RenameItem] {
        let urls = try FileManager.default.contentsOfDirectory(
            at: rootFolderURL,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )

        return urls
            .filter { $0.hasDirectoryPath }
            .map { url in
                let original = url.lastPathComponent
                let normalizedResult = NameNormalizer.normalize(original)
                let normalized = normalizedResult.value

                return RenameItem(
                    original: original,
                    normalized: normalized,
                    flagged: false
                )
            }
    }
}
