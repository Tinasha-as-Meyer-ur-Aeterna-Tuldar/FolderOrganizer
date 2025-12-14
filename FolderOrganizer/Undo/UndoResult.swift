import Foundation

struct UndoResult: Identifiable {

    let id = UUID()

    let applyResult: ApplyResult

    let success: Bool

    let restoredURL: URL?

    let error: UndoError?
}
