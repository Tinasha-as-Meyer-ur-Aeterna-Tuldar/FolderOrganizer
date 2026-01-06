// Services/FileScanService.swift
//
// フォルダを再帰的に走査し、リネーム対象となる
// ファイル／フォルダの URL を収集するサービス。
// UI や正規化ロジックには一切関与せず、
// 「ファイルシステム上に何が存在するか」だけを提供する。
//

import Foundation

/// ファイルスキャン専用サービス
final class FileScanService {

    /// スキャン結果
    struct ScanResult {
        /// 対象となる URL 一覧（ファイル or フォルダ）
        let urls: [URL]

        /// スキャン中に発生したエラー
        let errors: [ScanError]
    }

    /// スキャンエラー
    struct ScanError: Identifiable {
        let id = UUID()
        let url: URL
        let underlyingError: Error
    }

    /// ファイルマネージャ（テスト差し替え用）
    private let fileManager: FileManager

    /// 初期化
    /// - Parameter fileManager: 通常は `.default`
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    // MARK: - Public API

    /// 指定フォルダを再帰的にスキャンする
    /// - Parameters:
    ///   - rootURL: 起点となるフォルダ URL
    ///   - includeDirectories: フォルダ自体も対象に含めるか
    /// - Returns: ScanResult
    func scan(
        rootURL: URL,
        includeDirectories: Bool = true
    ) -> ScanResult {

        var collectedURLs: [URL] = []
        var errors: [ScanError] = []

        scanRecursively(
            at: rootURL,
            includeDirectories: includeDirectories,
            collectedURLs: &collectedURLs,
            errors: &errors
        )

        return ScanResult(
            urls: collectedURLs,
            errors: errors
        )
    }

    // MARK: - Internal

    /// 再帰的にフォルダを走査する
    private func scanRecursively(
        at url: URL,
        includeDirectories: Bool,
        collectedURLs: inout [URL],
        errors: inout [ScanError]
    ) {
        var isDirectory: ObjCBool = false

        guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            return
        }

        // フォルダ自体を対象に含める場合
        if isDirectory.boolValue, includeDirectories {
            collectedURLs.append(url)
        }

        // ファイルの場合はそのまま追加
        if !isDirectory.boolValue {
            collectedURLs.append(url)
            return
        }

        // フォルダ内を列挙
        do {
            let contents = try fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )

            for childURL in contents {
                scanRecursively(
                    at: childURL,
                    includeDirectories: includeDirectories,
                    collectedURLs: &collectedURLs,
                    errors: &errors
                )
            }

        } catch {
            errors.append(
                ScanError(
                    url: url,
                    underlyingError: error
                )
            )
        }
    }
}
