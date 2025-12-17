// Views/RenamePreviewList.swift
import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        RenamePreviewRowView(
                            item: item,
                            index: index,
                            isSelected: selectedIndex == index,
                            flagged: $items[index].flagged,
                            onSelect: {
                                selectedIndex = index
                                NotificationCenter.default.post(name: .openDetailFromList, object: index)
                            }
                        )
                        .id(item.id)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .onChange(of: selectedIndex) { _, newIndex in
                guard let idx = newIndex, items.indices.contains(idx) else { return }
                withAnimation {
                    proxy.scrollTo(items[idx].id, anchor: .center)
                }
            }
        }
    }
}
