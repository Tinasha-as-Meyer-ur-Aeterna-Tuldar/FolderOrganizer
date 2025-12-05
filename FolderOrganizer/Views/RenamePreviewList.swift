//  Views/RenamePreviewList.swift
import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    // 一覧の横幅をここで決める（全部この幅になる）
    private let listWidth: CGFloat = 900

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {

                VStack(alignment: .leading, spacing: 12) {
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
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedIndex = index
                        }
                    }
                }
                // 🔴 ここが超重要：VStack 全体の幅を固定
                .frame(width: listWidth, alignment: .leading)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
            }
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
