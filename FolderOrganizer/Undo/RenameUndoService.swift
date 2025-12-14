import Foundation

protocol RenameUndoService {

    /// ApplyResult を元に戻す
    func undo(_ result: ApplyResult) -> UndoResult
}
