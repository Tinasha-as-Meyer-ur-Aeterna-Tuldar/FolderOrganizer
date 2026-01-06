//
//  DefaultRenameUndoService.swift
//  FolderOrganizer
//

import Foundation

final class DefaultRenameUndoService: RenameUndoService {

    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func undo(
        rollback: RollbackInfo,
        completion: @escaping (UndoResult) -> Void
    ) {
        for move in rollback.moves {
            do {
                // すでに元に戻っていればスキップ（安全策）
                if fileManager.fileExists(atPath: move.to.path) {
                    completion(.success(move))
                    continue
                }

                try fileManager.moveItem(
                    at: move.from, // Apply 後の場所
                    to: move.to    // 元の場所
                )

                // ✅ 成功：move を渡す
                completion(.success(move))

            } catch {
                // ❌ 失敗：error を渡す
                completion(.failure(error))
            }
        }
    }
}
