// Views/RenamePreviewList.swift
import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    var body: some View {
        // ForEach 用に先にインデックス配列を作っておく
        let indices = Array(items.indices)

        return ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(indices, id: \.self) { index in
                        let item = items[index]

                        RenamePreviewRow(
                            original: item.original,
                            normalized: item.normalized,
                            isOdd: index.isMultiple(of: 2),
                            isSelected: selectedIndex == index,
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
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
            }
            // macOS 14 以降の新しい onChange シグネチャ
            .onChange(of: selectedIndex) { _, newValue in
                guard let idx = newValue else { return }
                withAnimation {
                    proxy.scrollTo(idx, anchor: .center)
                }
            }
        }
    }
}
