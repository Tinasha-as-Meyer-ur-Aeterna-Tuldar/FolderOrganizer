//
//  RoleDetectionService+UserDecision.swift
//  FolderOrganizer
//

import Foundation

extension DefaultRoleDetectionService {

    /// ユーザー判断（Subtitle 扱いするか否か）を反映した Role 判定
    func detectRoles(
        from tokens: NameTokens,
        userDecision: UserSubtitleDecision
    ) -> RoleDetectionResult {

        // ① まず自動判定
        let base = detectRoles(from: tokens)

        // ② maybeSubtitle が無ければそのまま返す
        guard let maybe = base.maybeSubtitle else {
            return base
        }

        // ③ ユーザー判断を反映
        switch userDecision {

        case .undecided:
            // 判断保留 → そのまま
            return base

        case .confirmAsSubtitle:
            // Subtitle として確定
            var roles = base.roles
            if !roles.contains(.subtitle) {
                roles.append(.subtitle)
            }

            return RoleDetectionResult(
                roles: roles,
                maybeSubtitle: nil,
                warnings: base.warnings
            )

        case .ignore:
            // Subtitle 扱いしない
            return RoleDetectionResult(
                roles: base.roles,
                maybeSubtitle: nil,
                warnings: base.warnings
            )
        }
    }
}
