import Foundation

extension DefaultRoleDetectionService {

    /// ユーザー判断を加味した Role 判定
    func detectRoles(
        from tokens: NameTokens,
        userDecision: UserSubtitleDecision
    ) -> RoleDetectionResult {

        var result = detectRoles(from: tokens)

        guard let maybe = result.maybeSubtitle else {
            return result
        }

        switch userDecision {
        case .undecided:
            return result

        case .confirmAsSubtitle:
            return RoleDetectionResult(
                author: result.author,
                title: result.title,
                subtitle: maybe,
                maybeSubtitle: nil
            )

        case .ignore:
            return RoleDetectionResult(
                author: result.author,
                title: result.title,
                subtitle: result.subtitle,
                maybeSubtitle: nil
            )
        }
    }
}
