// Utilities/NotificationName+Ext.swift
import Foundation

extension Notification.Name {

    /// すでに存在していた通知
    static let openDetailView = Notification.Name("openDetailView")

    /// 新しく追加（一覧から開く専用）
    static let openDetailFromList = Notification.Name("openDetailFromList")
}
