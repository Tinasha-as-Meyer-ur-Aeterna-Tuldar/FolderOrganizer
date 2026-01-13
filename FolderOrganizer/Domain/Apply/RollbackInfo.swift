//
//  RollbackInfo.swift
//  FolderOrganizer
//

import Foundation

/// Undo 全体の情報
struct RollbackInfo {

    /// 実際に戻す move の一覧
    let moves: [Move]

    struct Move: Identifiable {
        let id = UUID()
        let from: URL   // 現在の場所
        let to: URL     // 元の場所
    }
}
