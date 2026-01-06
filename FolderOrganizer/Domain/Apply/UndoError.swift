//
//  UndoError.swift
//  FolderOrganizer
//
//  Undo（rollback）失敗理由の定義
//

import Foundation

/// Undo（rollback）時のエラー
///
/// 設計方針:
/// - Domain 層の純粋なエラー型
/// - View / Service で共通に扱える
/// - LocalizedError に準拠（UI 表示用）
enum UndoError: LocalizedError, Hashable {

    /// Undo できる情報が存在しない
    case notApplicable

    /// Apply 後の対象が見つからない
    case appliedItemMissing(URL)

    /// 元の場所にすでに別の項目が存在する
    case originalLocationAlreadyExists(URL)

    /// ファイル操作に失敗
    case fileOperationFailed(message: String)

    // MARK: - LocalizedError

    var errorDescription: String? {
        switch self {
        case .notApplicable:
            return "Undo できる情報がありません。"

        case .appliedItemMissing(let url):
            return "Undo 対象が見つかりません: \(url.path)"

        case .originalLocationAlreadyExists(let url):
            return "元の場所に既に項目があります: \(url.path)"

        case .fileOperationFailed(let message):
            return "Undo に失敗しました: \(message)"
        }
    }
}
