//
//  RoleDetector.swift
//  FolderOrganizer
//

import Foundation

enum RoleDetector {

    static func detect(from name: String) -> RoleDetectionResult {
        var roles: [Role] = []

        if name.contains("【") || name.contains("[") {
            roles.append(.subtitle)
        }

        if name.contains("著") {
            roles.append(.author)
        }

        if roles.isEmpty {
            roles.append(.title)
        }

        return RoleDetectionResult(
            roles: roles
        )
    }
}
