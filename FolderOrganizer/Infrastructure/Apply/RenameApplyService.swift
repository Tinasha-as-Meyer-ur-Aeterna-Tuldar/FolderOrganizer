import Foundation

protocol RenameApplyService {
    func apply(
        plans: [RenamePlan],
        completion: @escaping ([ApplyResult]) -> Void
    )
}
