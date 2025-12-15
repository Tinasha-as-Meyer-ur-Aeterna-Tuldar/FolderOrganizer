// Views/RenamePreviewRowView.swift
import SwiftUI

struct RenamePreviewRowView: View {

    let item: RenameItem
    let index: Int
    let isSelected: Bool
    @Binding var flagged: Bool
    let onSelect: () -> Void

    var body: some View {
        RenamePreviewRow(
            original: item.original,
            displayName: item.displayNameForList,
            isOdd: index % 2 == 0,
            isSelected: isSelected,
            isModified: item.isModified,
            flagged: $flagged
        )
        .onTapGesture {
            onSelect()
        }
    }
}
