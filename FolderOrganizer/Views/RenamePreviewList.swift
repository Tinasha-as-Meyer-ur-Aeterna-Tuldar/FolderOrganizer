import SwiftUI

struct RenamePreviewList: View {
    @Binding var items: [RenameItem]
    
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    RenamePreviewRow(
                        original: items[index].original,
                        normalized: items[index].normalized,
                        isOdd: index % 2 == 1,
                        flagged: $items[index].flagged
                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedIndex = index
                        openDetail(index)
                    }
                }
            }
            .frame(maxWidth: .infinity) // ペア全体の幅をウィンドウに合わせる
        }
        .background(AppTheme.colors.background)
    }
    
    func openDetail(_ index: Int) {
        NotificationCenter.default.post(
            name: .openDetailView,
            object: index
        )
    }
}
