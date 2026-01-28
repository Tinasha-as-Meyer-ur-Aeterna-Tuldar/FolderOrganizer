// Domain/Role/FolderConfidence.swift

import Foundation

enum FolderConfidence {
    case high
    case medium
    case low

    var stars: String {
        switch self {
        case .high:   return "★★★"
        case .medium: return "★★☆"
        case .low:    return "★☆☆"
        }
    }
}
