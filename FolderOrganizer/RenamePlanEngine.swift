import Foundation

final class RenamePlanEngine {

    private let normalizationService: NameNormalizationService
    private let tokenizationService: NameTokenizationService
    private let roleDetectionService: DefaultRoleDetectionService
    private let contextResolutionService: ContextResolutionService
    private let planBuilder: RenamePlanBuilder

    init(
        normalizationService: NameNormalizationService = DefaultNameNormalizationService(),
        tokenizationService: NameTokenizationService = DefaultNameTokenizationService(),
        roleDetectionService: DefaultRoleDetectionService = DefaultRoleDetectionService(),
        contextResolutionService: ContextResolutionService = DefaultContextResolutionService(),
        planBuilder: RenamePlanBuilder = DefaultRenamePlanBuilder()
    ) {
        self.normalizationService = normalizationService
        self.tokenizationService = tokenizationService
        self.roleDetectionService = roleDetectionService
        self.contextResolutionService = contextResolutionService
        self.planBuilder = planBuilder
    }

    /// 通常 DryRun
    func generatePlan(for url: URL) -> RenamePlan {
        generatePlan(for: url, userDecision: .undecided)
    }

    /// ユーザー判断込み DryRun
    func generatePlan(
        for url: URL,
        userDecision: UserSubtitleDecision
    ) -> RenamePlan {

        let rawName = url.lastPathComponent
        let normalized = normalizationService.normalize(rawName)
        let tokens = tokenizationService.tokenize(normalized)

        let roles = roleDetectionService.detectRoles(
            from: tokens,
            userDecision: userDecision
        )

        let context = contextResolutionService.resolveContext(for: url)

        return planBuilder.build(
            originalURL: url,
            normalizedName: normalized,
            roles: roles,
            context: context
        )
    }
}
