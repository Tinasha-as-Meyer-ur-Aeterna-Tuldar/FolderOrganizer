import Foundation

struct RenamePlanExport: Codable {

    let version: ExportVersion
    let exportedAt: Date

    let originalPath: String
    let originalName: String

    let normalizedName: String

    let detectedAuthor: String?
    let title: String
    let subtitle: String?
    let maybeSubtitle: String?

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
        self.title = plan.title
        self.subtitle = plan.subtitle
        self.maybeSubtitle = plan.maybeSubtitle

        self.targetParentPath = plan.targetParentFolder.path
        self.targetName = plan.targetName

        self.warnings = plan.warnings.map { $0.message }
    }
}
