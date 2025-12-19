// Views/RenamePreviewRowView.swift
import SwiftUI

struct RenamePreviewRowView: View {
    let item: RenameItem
    let index: Int
    let isSelected: Bool

    @Binding var flagged: Bool
    let onSelect: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.original)
                    .font(.system(size: 12))
                    .opacity(0.75)

                Text(SpaceMarkerText.make(item.displayNameForList))
                .font(.system(size: 14, weight: .semibold))
            }

            Spacer()

            // 変更マーク（任意）
            if item.isModified {
                Text("●")
                    .font(.system(size: 12))
            }

            Toggle("", isOn: $flagged)
                .labelsHidden()
                .toggleStyle(.checkbox)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(isSelected ? Color.white.opacity(0.10) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture { onSelect() }
    }
}
