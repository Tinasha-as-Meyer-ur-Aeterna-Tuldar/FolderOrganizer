//
//  RoleDetectionResult.swift
//  FolderOrganizer
//

import Foundation

struct RoleDetectionResult: Hashable {

    /// 確定した役割
    let roles: [Role]

    /// Subtitle かもしれない（ユーザー判断待ち）
    let maybeSubtitle: String?

    /// 将来用（警告など）
    let warnings: [String]

    init(
        roles: [Role],
        maybeSubtitle: String? = nil,
        warnings: [String] = []
    ) {
        self.roles = roles
        self.maybeSubtitle = maybeSubtitle
        self.warnings = warnings
    }
}
