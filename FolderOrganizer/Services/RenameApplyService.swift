// Services/RenameApplyService.swift
//
// Apply（実ファイル move）を行うサービスの契約。
// - UI 既存実装に合わせて completion で結果配列を返す
//

import Foundation

protocol RenameApplyService {
    func apply(
        plans: [RenamePlan],
        completion: @escaping ([ApplyResult]) -> Void
    )
}
