//
//  Domain/Apply/ApplyError.swift
//  FolderOrganizer
//

import Foundation

/// Apply の失敗理由（Hashable にして ApplyResult を自動合成できるように）
enum ApplyError: Hashable, LocalizedError {
    case failedToCreateDirectory(URL)
    case destinationAlreadyExists(URL)
    case fileMoveFailed(from: URL, to: URL, message: String)

    var errorDescription: String? {
        switch self {
        case .failedToCreateDirectory(let url):
            return "フォルダ作成に失敗しました: \(url.path)"
        case .destinationAlreadyExists(let url):
            return "既に存在するため適用できません: \(url.lastPathComponent)"
        case .fileMoveFailed(let from, let to, let message):
            return "移動に失敗しました: \(from.lastPathComponent) → \(to.lastPathComponent)\n\(message)"
        }
    }
}
