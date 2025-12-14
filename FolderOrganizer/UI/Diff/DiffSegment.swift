import Foundation

enum DiffType {
    case unchanged
    case added
    case removed
}

struct DiffSegment: Identifiable {
    let id = UUID()
    let text: String
    let type: DiffType
}
