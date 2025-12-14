import Foundation

struct RenameChangeSummary {

    let total: Int
    let moveCount: Int
    let renameOnlyCount: Int
    let noChangeCount: Int
    let warningCount: Int
    let blockingCount: Int

    static func build(from plans: [RenamePlan]) -> RenameChangeSummary {

        var move = 0
        var renameOnly = 0
        var noChange = 0
        var warning = 0
        var blocking = 0

        for plan in plans {

            let originalParent = plan.originalURL.deletingLastPathComponent()
            let targetParent = plan.targetParentFolder

            let parentChanged = originalParent.path != targetParent.path
            let nameChanged = plan.originalName != plan.targetName

            if parentChanged {
                move += 1
            } else if nameChanged {
                renameOnly += 1
            } else {
                noChange += 1
            }

            if !plan.warnings.isEmpty {
                warning += 1
            }

            if plan.warnings.contains(where: {
                if case .authorNotDetected = $0 { return true }
                return false
            }) {
                blocking += 1
            }
        }

        return RenameChangeSummary(
            total: plans.count,
            moveCount: move,
            renameOnlyCount: renameOnly,
            noChangeCount: noChange,
            warningCount: warning,
            blockingCount: blocking
        )
    }
}
