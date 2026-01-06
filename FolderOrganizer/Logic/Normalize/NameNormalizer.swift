//
//  NameNormalizer.swift
//  FolderOrganizer
//

import Foundation

enum NameNormalizer {

    /// 正規化結果
    enum Result {
        case success(
            value: String,
            warnings: [String],
            flags: [NameFlag]
        )

        /// 正規化後の文字列（UI / Scan / Plan 共通）
        var value: String {
            switch self {
            case .success(let value, _, _):
                return value
            }
        }

        /// 将来用（今は未使用でもOK）
        var warnings: [String] {
            switch self {
            case .success(_, let warnings, _):
                return warnings
            }
        }

        var flags: [NameFlag] {
            switch self {
            case .success(_, _, let flags):
                return flags
            }
        }
    }

    /// 正規化エントリポイント
    static func normalize(_ input: String) -> Result {
        // 仮実装（今後ルール追加）
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        return .success(
            value: trimmed,
            warnings: [],
            flags: []
        )
    }
}
