//
//  ApplyResultExport.swift
//  FolderOrganizer
//

import Foundation

/// ApplyResult を JSON Export 用に変換した DTO
struct ApplyResultExport: Codable {

    // MARK: - Meta
    let version: ExportVersion
    let exportedAt: Date

    // MARK: - Paths
    let originalPath: String
    let appliedPath: String?

    // MARK: - Result
    let success: Bool
    let errorMessage: String?

    // MARK: - Init
    init(from result: ApplyResult) {
        self.version = .v1
        self.exportedAt = Date()

        switch result {

        case .success(
            plan: let plan,
            destinationURL: let destinationURL,
            rollback: _
        ):
            self.originalPath = plan.originalURL.path
            self.appliedPath = destinationURL.path
            self.success = true
            self.errorMessage = nil

        case .failure(let error):
            // failure 時は plan が存在しない設計
            self.originalPath = ""
            self.appliedPath = nil
            self.success = false
            self.errorMessage = error.localizedDescription
        }
    }
}
