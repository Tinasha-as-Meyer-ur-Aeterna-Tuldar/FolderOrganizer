// Domain/Apply/ApplyError.swift
//
// Apply（実ファイル move）で発生しうるエラー。
// - Export / UI 表示で使えるよう LocalizedError に準拠
//

import Foundation

enum ApplyError: Hashable, LocalizedError {

    case failedToCreateDirectory(URL)
    case destinationAlreadyExists(URL)
    case fileMoveFailed(from: URL, to: URL, message: String)

    var errorDescription: String? {
        switch self {
        case .failedToCreateDirectory(let url):
            return "フォルダ作成に失敗しました: \(url.path)"

        case .destinationAlreadyExists(let url):
            return "既に存在するため適用できません: \(url.path)"

        case .fileMoveFailed(let from, let to, let message):
            return """
            移動に失敗しました:
            \(from.path) → \(to.path)
            \(message)
            """
        }
    }
}
