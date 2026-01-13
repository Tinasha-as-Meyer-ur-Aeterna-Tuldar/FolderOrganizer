// Services/ContextResolutionService.swift
import Foundation

protocol ContextResolutionService {

    /// URL の置かれている文脈を解決する
    func resolveContext(for url: URL) -> ContextInfo
}

final class DefaultContextResolutionService: ContextResolutionService {

    func resolveContext(for url: URL) -> ContextInfo {

        let parent = url.deletingLastPathComponent()
        let parentName = parent.lastPathComponent

        // 作者フォルダ判定
        let authorFolderName = detectAuthorFolderName(from: parentName)

        return ContextInfo(
            currentParent: parent,
            isUnderAuthorFolder: authorFolderName != nil,
            detectedAuthorFolderName: authorFolderName,
            duplicateNameExists: false   // ← DryRunでは未判定
        )
    }
}

// MARK: - Private helpers
private extension DefaultContextResolutionService {

    /// 作者フォルダ名を検出する
    func detectAuthorFolderName(from folderName: String) -> String? {
        // 仮実装（あとで育てる）
        guard !folderName.isEmpty else { return nil }
        return folderName
    }
}
