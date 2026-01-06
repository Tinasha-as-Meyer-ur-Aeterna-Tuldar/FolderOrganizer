//
//  RoleDetectionService.swift
//  FolderOrganizer
//

import Foundation

final class DefaultRoleDetectionService {

    func detectRoles(from tokens: NameTokens) -> RoleDetectionResult {

        var roles: [Role] = []
        var maybeSubtitle: String?

        if tokens.hasAuthor {
            roles.append(.author)
        }

        if tokens.hasExplicitSubtitle {
            roles.append(.subtitle)
        } else if let candidate = tokens.subtitleCandidate {
            maybeSubtitle = candidate
        }

        if roles.isEmpty {
            roles.append(.title)
        }

        return RoleDetectionResult(
            roles: roles,
            maybeSubtitle: maybeSubtitle
        )
    }
}
