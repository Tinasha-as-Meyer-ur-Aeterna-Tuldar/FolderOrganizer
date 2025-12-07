// Models/RenameItem.swift
import Foundation

/// 一覧・詳細で共有するデータモデル
struct RenameItem: Identifiable, Hashable {
    let id = UUID()

    let original: String          // 元名
    var normalized: String        // 正規化後の名前
    var flagged: Bool             // 手動フラグ（「おかしい？」）

    /// 手動修正結果（未修正なら nil）
    var manual: String?
}
