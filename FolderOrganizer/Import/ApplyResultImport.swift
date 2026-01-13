import Foundation

struct ApplyResultImport: Codable {

    let version: ExportVersion

    let originalPath: String
    let appliedPath: String?
    let success: Bool
}
