// Logic/DetectedRole.swift
//
// 文字列から推定された「役割」情報。
// - Hashable/Equatable/Codable が要求されがちなので、最初から対応しておく
// - RoleSource が無いとコンパイルできないため RoleSource.swift とセット
//

import Foundation

struct DetectedRole: Hashable, Codable {

    /// 例: "author", "circle", "title" など（現段階では自由文字列でOK）
    let role: String

    /// 推定した元情報
    let source: RoleSource

    /// 推定に使った生データ（任意）
    let raw: String?

    init(role: String, source: RoleSource, raw: String? = nil) {
        self.role = role
        self.source = source
        self.raw = raw
    }
}
