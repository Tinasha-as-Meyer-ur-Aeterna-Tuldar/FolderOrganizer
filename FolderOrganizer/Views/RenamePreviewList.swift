//  Views/RenamePreviewList.swift
import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]
    @Binding var selectedIndex: Int?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {

                VStack(alignment: .center, spacing: 10) {

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

                            // ★ 行クリックで詳細を開く
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(
                                    name: .openDetailFromList,
                                    object: nil
                                )
                            }
                        }
                        .frame(maxWidth: 720)     // 中央揃えの最大幅
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity)
            .background(AppTheme.colors.background)

            // 選択行が変わったらスクロール追従
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
