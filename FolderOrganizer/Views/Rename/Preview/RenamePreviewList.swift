//
// Views/Rename/Preview/RenamePreviewList.swift
// 【差し替え】Preview 全体ラッパー
//
import SwiftUI

/// 旧 RenamePreviewList（互換用）
struct RenamePreviewList: View {

    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    let showSpaceMarkers: Bool
    let onSelect: (Int) -> Void

    var body: some View {
        ScrollView {
            PreviewListContent(
                items: $items,
                selectedIndex: $selectedIndex,
                showSpaceMarkers: showSpaceMarkers,
                onSelect: onSelect
            )
        }
    }
}
