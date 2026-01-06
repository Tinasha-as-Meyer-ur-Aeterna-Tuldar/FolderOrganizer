//
// ApplyResult.swift
//

import Foundation

enum ApplyResult {
    case success(
        plan: RenamePlan,
        destinationURL: URL,
        rollback: RollbackInfo
    )
    case failure(error: Error)

    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}
