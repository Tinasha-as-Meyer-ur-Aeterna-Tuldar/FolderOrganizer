import SwiftUI

struct RenameDetailView: View {
    let item: RenameItem
    let index: Int
    let total: Int
    let onPrev: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // 旧
            Text("旧:")
                .font(.system(size: 18, weight: .bold))
            Text(item.original)
                .font(.system(size: 24))
                .fixedSize(horizontal: false, vertical: true)
            
            // 新（スペースを全部 ␣ 赤表示）
            Text("新:")
                .font(.system(size: 18, weight: .bold))
            DiffBuilder.highlightSpaces(in: item.normalized)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppTheme.colors.newText)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            // ナビゲーション（↑↓で前後に移動する想定）
            HStack {
                Button("↑ 前へ") {
                    onPrev()
                }
                .keyboardShortcut(.upArrow)
                
                Spacer()
                
                Text("\(index + 1) / \(total)")
                    .font(.system(size: 16))
                
                Spacer()
                
                Button("↓ 次へ") {
                    onNext()
                }
                .keyboardShortcut(.downArrow)
            }
            .font(.system(size: 16))
        }
        .padding(24)
        .frame(minWidth: 900, minHeight: 500)
    }
}
