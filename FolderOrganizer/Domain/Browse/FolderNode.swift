// FolderOrganizer/Domain/Browse/FolderNode.swift
//
// フォルダツリーのノード
// - OutlineGroup で表示できるよう Identifiable
// - children は Optional（nil = leaf）にして SwiftUI の要求に合わせる
// - B-2b: 親フォルダ昇格（子が VOLUME を含むなら親を SERIES へ）
// - C-1 : 確信度（最小）を付与
//

import Foundation

struct FolderNode: Identifiable {

    // MARK: - Identity

    let id = UUID()

    // MARK: - Core

    let name: String
    let url: URL

    /// 直下の「ファイル数」（ディレクトリは含めない）
    let fileCount: Int

    /// 推定された役割
    var roleHint: FolderRoleHint

    /// 役割推定の確信度（C-1）
    var confidence: RoleConfidence

    /// 子ノード（nil = leaf）
    var children: [FolderNode]?

    // MARK: - B-2b: Parent Promotion (Role Fixup)

    mutating func fixupRoleFromChildren() {
        guard var children else { return }

        // 先に子を fixup（深さ優先）
        for i in children.indices {
            var c = children[i]
            c.fixupRoleFromChildren()
            children[i] = c
        }

        // 自分が UNKNOWN のとき、子に VOLUME がいれば SERIES へ昇格
        if roleHint == .unknown {
            let childRoles = children.map { $0.roleHint }
            if childRoles.contains(.volume) {
                roleHint = .series
            }
        }

        self.children = children.isEmpty ? nil : children
    }

    // MARK: - C-1: Confidence Fixup (Minimal)

    mutating func fixupConfidence(parentRoleHint: FolderRoleHint?) {
        // 子を先に処理
        if var children {
            for i in children.indices {
                var c = children[i]
                c.fixupConfidence(parentRoleHint: self.roleHint)
                children[i] = c
            }
            self.children = children.isEmpty ? nil : children
        }

        // --- 最小ルール（後で差し替え前提） ---
        // VOLUME は名前パターンにより直接判定されている想定なので高め
        if roleHint == .volume {
            confidence = .high
            return
        }

        // SERIES は子に VOLUME が複数あるほど根拠が強い
        if roleHint == .series {
            let volumeChildren = (children ?? []).filter { $0.roleHint == .volume }.count
            confidence = (volumeChildren >= 2) ? .high : .medium
            return
        }

        // UNKNOWN は「親が SERIES」なら一段マシ、それ以外は低
        if roleHint == .unknown {
            if parentRoleHint == .series {
                confidence = .medium
            } else {
                confidence = .low
            }
        }
    }
}
