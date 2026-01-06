// Services/RenameItemBuilder.swift
//
// FileScanService が収集した URL 一覧から、
// UI やリネーム処理で使用する RenameItem を生成する。
// 正規化・分類ロジックは Logic レイヤに委譲し、
// このクラスは「橋渡し」だけを責務とする。
//

import Foundation

/// RenameItem 生成専用ビルダー
final class RenameItemBuilder {

    // MARK: - Public API

    /// URL 一覧から RenameItem を生成する
    func build(from urls: [URL]) -> [RenameItem] {
        urls.compactMap { url in
            buildRenameItem(from: url)
        }
    }

    // MARK: - Internal

    /// 単一 URL から RenameItem を生成
    private func buildRenameItem(from url: URL) -> RenameItem? {

        let originalName = url.lastPathComponent

        guard !originalName.isEmpty else {
            return nil
        }

        let result = NameNormalizer.normalize(originalName)
        let normalizedName = result.normalized

        return RenameItem(
            original: originalName,
            normalized: normalizedName,
            flagged: originalName != normalizedName
        )
    }
}
