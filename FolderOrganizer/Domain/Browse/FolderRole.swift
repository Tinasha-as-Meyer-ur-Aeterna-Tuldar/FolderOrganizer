// Domain/Browse/FolderRole.swift
//
// フォルダの意味的な役割（表示専用・推定）
// - 実ファイル構造は一切変更しない
//

import Foundation

enum FolderRole: String {
    case series
    case volume
    case images
    case unknown
}
