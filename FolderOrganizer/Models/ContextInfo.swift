import Foundation

struct ContextInfo {
    let currentParent: URL
    let isUnderAuthorFolder: Bool
    let detectedAuthorFolderName: String?
    let duplicateNameExists: Bool
}
