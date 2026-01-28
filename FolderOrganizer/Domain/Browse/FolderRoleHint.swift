// FolderOrganizer/Domain/Browse/FolderRoleHint.swift
//
// 役割推定（B-2）
// - フォルダ名や構造から「SERIES / VOLUME / UNKNOWN」を推定する
// - ここでは「最終的にどう扱うべきか」のヒント（hint）として扱う
//

import Foundation

enum FolderRoleHint: String, Codable {
    case series = "SERIES"
    case volume = "VOLUME"
    case unknown = "UNKNOWN"
}
