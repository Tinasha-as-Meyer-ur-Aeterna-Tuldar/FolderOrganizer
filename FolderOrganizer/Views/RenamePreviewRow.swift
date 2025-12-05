import SwiftUI

struct RenamePreviewRow: View {
    let original: String
    let normalized: String
    let isOdd: Bool
    @Binding var flagged: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // 新
            HStack(alignment: .top, spacing: 8) {
                Text("新:")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.colors.newText)
                
                DiffBuilder.highlightSpaces(in: normalized)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.colors.newText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 旧
            HStack(alignment: .top, spacing: 8) {
                Text("旧:")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(AppTheme.colors.oldText)
                
                Text(original)
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.colors.oldText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // チェック
            HStack {
                Toggle(isOn: $flagged) {
                    Text("おかしい？")
                        .font(.system(size: 13))
                }
                .toggleStyle(.checkbox)
                Spacer()
            }
            .padding(.top, 2)
            
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            flagged
            ? AppTheme.colors.cardFlagged
            : (isOdd ? AppTheme.colors.cardAlt : AppTheme.colors.card)
        )
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(AppTheme.colors.border),
            alignment: .bottom
        )
    }
}
