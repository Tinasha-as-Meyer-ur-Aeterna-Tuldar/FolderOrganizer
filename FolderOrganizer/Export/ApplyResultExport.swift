import Foundation

struct ApplyResultExport: Codable {

    let version: ExportVersion
    let exportedAt: Date

    let originalPath: String
    let appliedPath: String?

    let success: Bool
    let errorMessage: String?

    init(from result: ApplyResult) {
        self.version = .v1
        self.exportedAt = Date()

        self.originalPath = result.plan.originalURL.path
        self.appliedPath = result.appliedURL?.path

        self.success = result.success
        self.errorMessage = result.error?.localizedDescription
    }
}
