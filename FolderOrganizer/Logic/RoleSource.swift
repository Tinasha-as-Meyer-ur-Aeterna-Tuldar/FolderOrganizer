// Logic/RoleSource.swift
//
// 役割（作者名/作品名など）をどこから推定したかの情報源。
// DetectedRole.swift で参照されるため、型として必ず定義しておく。
// ※ 仕様は今後拡張してOK（Phase 2 以降でログに活かせる）
//

import Foundation

enum RoleSource: String, Codable, Hashable {
    case unknown
    case folderName
    case parentFolder
    case bracket
    case pattern
    case heuristic
}
