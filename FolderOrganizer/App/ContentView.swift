// ContentView.swift
import SwiftUI

struct ContentView: View {

    @State private var items: [RenameItem] = []
    @State private var selectedIndex: Int? = nil

    @State private var editingText: String = ""
    @State private var isEditing: Bool = false

    var body: some View {
        ZStack {

            // =========================
            // メイン一覧
            // =========================
            VStack(spacing: 0) {

                Text("Folder Organizer")
                    .font(.largeTitle)
                    .padding(.top, 20)

                Button("フォルダ名を読み込んで変換プレビュー") {
                    loadDummy()
                }
                .buttonStyle(.borderedProminent)
                .padding()

                List {
                    ForEach(items.indices, id: \.self) { index in
                        RenamePreviewRowView(
                            item: items[index],
                            index: index,
                            isSelected: selectedIndex == index,
                            flagged: $items[index].flagged
                        ) {
                            selectedIndex = index
                            editingText = items[index].displayNameForList
                            isEditing = true
                        }
                    }
                }
                .listStyle(.plain)
            }

            // =========================
            // 編集オーバーレイ
            // =========================
            if isEditing, let index = selectedIndex {

                // 背景ディマー（半透明・透け防止）
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .onTapGesture {
                        closeEditor()
                    }

                // 編集カード（完全不透明）
                RenameEditView(
                    original: items[index].original,
                    edited: $editingText,
                    onCommit: {
                        items[index].edited = editingText
                        closeEditor()
                    },
                    onCancel: {
                        closeEditor()
                    }
                )
                .background(AppTheme.colors.cardBackground) // ← ★ここが修正点
                .cornerRadius(14)
                .shadow(radius: 24)
                .padding()
            }
        }
    }

    // MARK: - Helpers

    private func closeEditor() {
        isEditing = false
        selectedIndex = nil
        editingText = ""
    }

    private func loadDummy() {
        items = [
            RenameItem(
                original: "[diletta] 愛獣に飢えた渋谷令嬢をメス堕ちさせるまで飼いならし、堕ろ。",
                normalized: "[diletta] 愛獣に飢えた渋谷令嬢をメス堕ちさせるまで飼いならし、堕ろ。",
                edited: "",
                flagged: false
            )
        ]
    }
}
