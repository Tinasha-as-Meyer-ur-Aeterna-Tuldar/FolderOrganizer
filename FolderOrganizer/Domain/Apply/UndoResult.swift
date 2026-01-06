//
//  UndoResult.swift
//  FolderOrganizer
//

import Foundation

enum UndoResult: Identifiable {

    case success(RollbackInfo.Move)
    case failure(Error)

    var id: String {
        switch self {
        case .success(let move):
            return "success-\(move.id.uuidString)"
        case .failure(let error):
            return "failure-\(error.localizedDescription)"
        }
    }
}
