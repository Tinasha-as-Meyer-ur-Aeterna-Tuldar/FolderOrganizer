// Views/RenamePreviewList.swift
import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        RenamePreviewRowView(
                            item: item,
                            index: index,
                            isSelected: index == selectedIndex,
                            flagged: $items[index].flagged,
                            onSelect: {
                                selectedIndex = index
                                NotificationCenter.default.post(
                                    name: .openDetailFromList,
                                    object: index
                                )
                            }
                        )
                        .id(item.id)
                    }
                }
                .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity)
            .background(AppTheme.colors.background)
            .onChange(of: selectedIndex) { newIndex in
                if let idx = newIndex {
                    withAnimation {
                        proxy.scrollTo(items[idx].id, anchor: .center)
                    }
                }
            }
        }
    }
}
