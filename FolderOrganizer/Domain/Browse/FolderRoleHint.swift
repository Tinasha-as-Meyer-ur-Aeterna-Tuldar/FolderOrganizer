// FolderOrganizer/Domain/Browse/FolderRoleHint.swift
//
// フォルダの「役割ヒント」を表す enum（表示専用）
// - まずは B-2a のために SERIES / VOLUME を推定できるようにする
// - 推定できない場合は UNKNOWN
//

import Foundation

enum FolderRoleHint: String, Codable, Hashable {
    case unknown
    case series
    case volume

    var displayName: String {
        switch self {
        case .unknown: return "UNKNOWN"
        case .series:  return "SERIES"
        case .volume:  return "VOLUME"
        }
    }
}
