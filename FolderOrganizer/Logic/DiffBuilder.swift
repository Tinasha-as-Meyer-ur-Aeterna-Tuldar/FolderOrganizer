//
//  Logic/DiffBuilder.swift
//  FolderOrganizer
//
//  まずは最小の差分表示：
//  same / removed / added の 3 トークン（将来 LCS に差し替え可能）
//

import Foundation

enum DiffBuilder {

    static func build(original: String, modified: String) -> [DiffToken] {
        guard original != modified else {
            return [DiffToken(text: original, kind: .same)]
        }

        return [
            DiffToken(text: original, kind: .removed),
            DiffToken(text: " → ", kind: .same),
            DiffToken(text: modified, kind: .added)
        ]
    }
}
