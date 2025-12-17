import Foundation

/// NameNormalizer の結果（純粋データ）
struct NormalizationResult {
    let originalName: String
    let normalizedName: String
    let tokens: [String]
    let warnings: [RenameWarning]
}
