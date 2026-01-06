//
//  RenameItem.swift
//  FolderOrganizer
//

import Foundation

struct RenameItem: Identifiable, Hashable, Codable {

    // MARK: - Identity
    var id: UUID

    // MARK: - Core
    var original: String
    var normalized: String
    var flagged: Bool

    // MARK: - Computed
    var finalName: String { normalized }

    var isSubtitle: Bool {
        TextClassifier.isSubtitle(normalized)
    }

    var isPotentialSubtitle: Bool {
        TextClassifier.isPotentialSubtitle(normalized)
    }

    // MARK: - Init
    init(
        id: UUID = UUID(),
        original: String,
        normalized: String,
        flagged: Bool = false
    ) {
        self.id = id
        self.original = original
        self.normalized = normalized
        self.flagged = flagged
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id
        case original
        case normalized
        case flagged
    }
}
