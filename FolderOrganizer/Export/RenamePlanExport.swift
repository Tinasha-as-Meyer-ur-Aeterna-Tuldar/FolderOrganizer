import Foundation

/// RenamePlan の書き出し用 DTO
struct RenamePlanExport: Codable {

    enum Version: String, Codable {
        case v1
    }

    let version: Version
    let exportedAt: Date

    let originalPath: String
    let originalName: String
    let normalizedName: String

    let detectedAuthor: String?

    let targetParentPath: String
    let targetName: String

    let warnings: [String]

    init(from plan: RenamePlan) {
        self.version = .v1
        self.exportedAt = Date()

        self.originalPath = plan.originalURL.path
        self.originalName = plan.originalName
        self.normalizedName = plan.normalizedName

        self.detectedAuthor = plan.detectedAuthor

        self.targetParentPath = plan.targetParentFolder.path
        self.targetName = plan.targetName

        self.warnings = plan.warnings.map { $0.message }
    }
}
