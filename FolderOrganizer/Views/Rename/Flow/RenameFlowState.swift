import Foundation

enum RenameFlowState {
    case preview
    case applying
    case applied(results: [ApplyResult])
    case undoing
}
