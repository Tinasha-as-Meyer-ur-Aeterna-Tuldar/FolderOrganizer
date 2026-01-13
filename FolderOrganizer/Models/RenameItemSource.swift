// Models/RenameItemSource.swift
//
// RenameItem がどの経路で生成されたかを表す。
// ※ この enum はプロジェクト内で「唯一の定義」とする
//

import Foundation

enum RenameItemSource: String, Codable, Hashable {
    case auto
    case user
    case imported
}
