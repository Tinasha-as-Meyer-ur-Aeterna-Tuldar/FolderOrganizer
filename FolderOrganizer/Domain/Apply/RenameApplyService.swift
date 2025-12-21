import Foundation

protocol RenameApplyService {

    /// RenamePlan を実ファイルに反映する
    func apply(_ plan: RenamePlan) -> ApplyResult
}
