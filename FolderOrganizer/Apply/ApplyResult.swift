import Foundation

struct ApplyResult: Identifiable {

    let id = UUID()

    let plan: RenamePlan

    let success: Bool

    let appliedURL: URL?

    let error: ApplyError?
}
