//
//  ApplyResultRow.swift
//  FolderOrganizer
//

import SwiftUI

struct ApplyResultRow: Identifiable {

    let id = UUID()
    let title: String
    let detail: String?
    let succeeded: Bool

    init(result: ApplyResult) {
        switch result {

        case .success(let plan, let destinationURL, _):
            self.title = plan.originalURL.lastPathComponent
            self.detail = "→ \(destinationURL.lastPathComponent)"
            self.succeeded = true

        case .failure(let error):
            self.title = "Apply 失敗"
            self.detail = error.localizedDescription
            self.succeeded = false
        }
    }
}
