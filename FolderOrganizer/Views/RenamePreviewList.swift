// Views/RenamePreviewList.swift
import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]

                        RenamePreviewRow(
                            original: item.original,
                            normalized: item.normalized,
                            isOdd: index % 2 == 0,
                            isSelected: index == selectedIndex,
                            flagged: $items[index].flagged
                        )
                        .id(index)
                        .onTapGesture {
                            selectedIndex = index
                            NotificationCenter.default.post(
                                name: .openDetailFromList,
                                object: index
                            )
                        }
                    }
                }
                // 🔵 両側の余白だけ固定、中央のカードは可変
                .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity)              // ScrollView 自体も横いっぱい
            .background(AppTheme.colors.background)

            .onChange(of: selectedIndex) { newIndex in
                if let idx = newIndex {
                    withAnimation {
                        proxy.scrollTo(idx, anchor: .center)
                    }
                }
            }
        }
    }
}
