import Foundation

struct RenamePlanImport: Codable {

    let version: ExportVersion

    let originalPath: String
    let normalizedName: String

    let detectedAuthor: String?
    let title: String
    let subtitle: String?
    let maybeSubtitle: String?

    let targetParentPath: String
    let targetName: String
}
