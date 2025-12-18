// Domain/NormalizationResult.swift
import Foundation

/// 正規化処理の結果
struct NormalizationResult {

    /// 元の名前
    let original: String

    /// 正規化後の名前
    let normalizedName: String

    /// 正規化時に発生した警告
    let warnings: [RenameWarning]

    /// 互換用イニシャライザ（将来 tokens 等を足す前提）
    init(
        original: String,
        normalizedName: String,
        warnings: [RenameWarning] = []
    ) {
        self.original = original
        self.normalizedName = normalizedName
        self.warnings = warnings
    }
}
