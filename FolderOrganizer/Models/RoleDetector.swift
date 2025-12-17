// Domain/RoleDetector.swift
import Foundation

struct RoleDetectionResult {
    var author: String?
    var title: String
    var subtitle: String?
    var maybeSubtitle: String?
}

enum RoleDetector {
    static func detect(from normalizedName: String) -> RoleDetectionResult {
        // 仮実装（あとで育てる）
        RoleDetectionResult(
            author: nil,
            title: normalizedName,
            subtitle: nil,
            maybeSubtitle: nil
        )
    }
}
