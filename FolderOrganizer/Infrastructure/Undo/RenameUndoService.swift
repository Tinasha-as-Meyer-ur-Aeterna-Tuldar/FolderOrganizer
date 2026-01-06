//
//  RenameUndoService.swift
//

import Foundation

protocol RenameUndoService {
    func undo(
        rollback: RollbackInfo,
        completion: @escaping (UndoResult) -> Void
    )
}
