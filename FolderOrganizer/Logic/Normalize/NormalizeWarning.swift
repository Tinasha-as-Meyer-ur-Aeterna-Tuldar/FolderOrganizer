//
//  NormalizeWarning.swift
//  FolderOrganizer
//

import Foundation

struct NormalizeWarning: Identifiable, Hashable {
    let id = UUID()

    /// 表示用メッセージ
    let message: String

    /// 元の名前（必要なら）
    let originalName: String?

    /// 正規化後の名前（必要なら）
    let normalizedName: String?
}
