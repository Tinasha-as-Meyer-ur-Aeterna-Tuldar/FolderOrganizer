// Models/RenameIssue.swift
//
// RenameItem が抱える注意点・警告
// ✅ ここを「唯一の定義」にする（RenameItem.swift 側に enum を置かない）
//

import Foundation

enum RenameIssue: String, Codable, Hashable, CaseIterable {
    case subtitle
    case potentialSubtitle
}
