// Domain/Normalize/NormalizeResult.swift

import Foundation

/// 正規化の結果
struct NormalizeResult {
    /// 正規化後の名前
    let value: String

    /// 正規化時に発生した警告
    let warnings: [NormalizeWarning]
}
