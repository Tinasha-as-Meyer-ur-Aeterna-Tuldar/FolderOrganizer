import Foundation

struct ContextInfo: Hashable {
    let currentParent: URL
    let isUnderAuthorFolder: Bool
    let detectedAuthorFolderName: String?
    let duplicateNameExists: Bool
}
