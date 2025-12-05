//  Views/ContentView.swift
import SwiftUI

struct ContentView: View {

    @State private var items: [RenameItem] = FileScanService.loadSampleNames()
    @State private var selectedIndex: Int? = nil
    @State private var showingDetail = false

    var body: some View {
        ZStack {
            // 背景＋タイトル＋ボタン＋一覧
            VStack(spacing: 24) {

                // タイトル
                Text("Folder Organizer")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppTheme.colors.title)
                    .padding(.top, 24)

                // フォルダ読み込みボタン（今はサンプル再読込）
                Button {
                    items = FileScanService.loadSampleNames()
                    if items.isEmpty {
                        selectedIndex = nil
                    } else {
                        selectedIndex = 0
                    }
                } label: {
                    Text("フォルダ名を読み込んで変換プレビュー")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.colors.primaryButton)

                // 一覧
                RenamePreviewList(
                    items: $items,
                    selectedIndex: $selectedIndex
                )

                Spacer(minLength: 16)
            }
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(AppTheme.colors.background)

            // 詳細ポップアップ
            if showingDetail,
               let idx = selectedIndex,
               items.indices.contains(idx) {

                Color.black.opacity(0.25)
                    .ignoresSafeArea()

                RenameDetailView(
                    item: items[idx],
                    index: idx,
                    total: items.count,
                    onPrev: movePrev,
                    onNext: moveNext,
                    onClose: { showingDetail = false }
                )
            }
        }
        // キーボード操作（上下：選択移動、Return：詳細、ESC：閉じる）
        .onKeyDown { event in
            switch event.keyCode {
            case 126: // ↑
                moveSelection(delta: -1)
            case 125: // ↓
                moveSelection(delta: 1)
            case 36:  // Return
                openDetail()
            case 53:  // ESC
                showingDetail = false
            default:
                break
            }
        }
    }

    // MARK: - キーボード用ヘルパー

    private func moveSelection(delta: Int) {
        guard !items.isEmpty else { return }

        let current = selectedIndex ?? 0
        var next = current + delta
        next = max(0, min(items.count - 1, next))
        selectedIndex = next
    }

    private func openDetail() {
        guard !items.isEmpty else { return }
        if selectedIndex == nil {
            selectedIndex = 0
        }
        showingDetail = true
    }

    private func movePrev() { moveSelection(delta: -1) }
    private func moveNext() { moveSelection(delta: 1) }
}
