import Foundation

struct RenameItem: Identifiable {
    let id = UUID()
    let original: String
    let normalized: String
    var flagged: Bool = false
}
