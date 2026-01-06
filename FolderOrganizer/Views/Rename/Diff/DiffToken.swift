//
//  Views/Rename/Diff/DiffToken.swift
//  FolderOrganizer
//

import Foundation

struct DiffToken: Identifiable, Hashable {
    enum Kind: Hashable {
        case same
        case added
        case removed
    }

    let id = UUID()
    let text: String
    let kind: Kind
}
