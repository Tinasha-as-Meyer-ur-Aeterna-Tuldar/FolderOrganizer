// Services/FileScanService.swift
//
// フォルダ配下をスキャンし、リネーム対象となる URL 一覧を返す。
// 選択された rootURL 自身は結果に含めない。
//

import Foundation

final class FileScanService {

    // MARK: - Result

    struct ScanResult {
        let urls: [URL]
        let errors: [Error]
    }

    // MARK: - Public

    func scan(rootURL: URL) -> ScanResult {

        var collected: [URL] = []
        var errors: [Error] = []

        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: rootURL,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            for url in contents {
                do {
                    // フォルダ or ファイル判定（今後拡張しやすい形）
                    _ = try url.resourceValues(forKeys: [.isDirectoryKey])

                    // ✅ rootURL の「直下」だけを対象にする
                    collected.append(url)

                } catch {
                    errors.append(error)
                }
            }

        } catch {
            errors.append(error)
        }

        return ScanResult(
            urls: collected,
            errors: errors
        )
    }
}
