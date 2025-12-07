//  Views/ContentView.swift
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {

    // 一覧データ
    @State private var items: [RenameItem] = []
    @State private var selectedIndex: Int? = nil

    // 詳細ポップアップ
    @State private var showingDetail = false

    // 編集ポップアップ
    @State private var showingEdit = false
    @State private var editText: String = ""   // 編集用テキスト（旧のコピー）

    // MARK: - Body

    var body: some View {
        ZStack {
            VStack(spacing: 24) {

                // タイトル
                Text("FolderOrganizer")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.top, 20)

                // フォルダ読み込みボタン
                Button(action: selectFolderAndLoad) {
                    Text("フォルダを読み込む")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                        .background(AppTheme.colors.primaryButton)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)

                // 一覧
                if items.isEmpty {
                    Spacer()
                } else {
                    listView
                }
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.colors.background)
        // 詳細シート
        .sheet(isPresented: $showingDetail) {
            if !items.isEmpty {
                let index = selectedIndex ?? 0

                RenameDetailView(
                    item: items[index],
                    index: index,
                    total: items.count,
                    onPrev: {
                        moveSelection(delta: -1)
                    },
                    onNext: {
                        moveSelection(delta: +1)
                    },
                    onClose: {
                        showingDetail = false
                    },
                    onEdit: {
                        // 旧の文字列を編集テキストとしてコピー
                        if let current = selectedIndex {
                            editText = items[current].original
                        } else {
                            selectedIndex = index
                            editText = items[index].original
                        }
                        // 詳細を閉じて編集モードへ
                        showingDetail = false
                        showingEdit = true
                    }
                )
            } else {
                Text("項目がありません")
                    .padding(40)
            }
        }
        // 編集シート
        .sheet(isPresented: $showingEdit) {
            if let idx = selectedIndex, idx < items.count {
                RenameEditView(
                    editText: $editText,
                    onCommit: { newText in
                        // 保存：編集結果を「新」に反映
                        items[idx].normalized = newText
                        showingEdit = false
                        showingDetail = true     // いったん詳細へ戻る
                    },
                    onCancel: {
                        // 破棄：元の詳細に戻る
                        showingEdit = false
                        showingDetail = true
                    }
                )
            } else {
                Text("編集対象がありません")
                    .padding(40)
            }
        }
    }

    // MARK: - LIST VIEW

    private var listView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {

                    // indices を変数にするとコンパイラエラーを回避しやすい
                    let allIndices = items.indices

                    ForEach(allIndices, id: \.self) { index in
                        let item = items[index]
                        let isOdd = index.isMultiple(of: 2)
                        let isSelected = (selectedIndex == index)

                        RenamePreviewRow(
                            original: item.original,
                            normalized: item.normalized,
                            isOdd: isOdd,
                            isSelected: isSelected,
                            flagged: $items[index].flagged
                        )
                        .id(index)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedIndex = index
                            showingDetail = true
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
            .focusable(true)
            .onKeyDown { event in
                handleKey(event, proxy: proxy)
            }
        }
    }

    // MARK: - キー操作（一覧）

    private func handleKey(_ event: NSEvent, proxy: ScrollViewProxy) {
        // 詳細 or 編集を表示している間は一覧のキー操作は無効
        if showingDetail || showingEdit {
            return
        }

        guard !items.isEmpty else { return }

        let current = selectedIndex ?? 0
        var newIndex = current

        switch event.keyCode {
        case 126: // ↑
            newIndex = max(current - 1, 0)

        case 125: // ↓
            newIndex = min(current + 1, items.count - 1)

        case 36, 76: // Enter / Return
            selectedIndex = current
            openDetail()
            return

        default:
            return
        }

        if newIndex != current {
            selectedIndex = newIndex
            withAnimation {
                proxy.scrollTo(newIndex, anchor: .center)
            }
        }
    }

    private func moveSelection(delta: Int) {
        guard !items.isEmpty else { return }

        let current = selectedIndex ?? 0
        var next = current + delta
        next = max(0, min(items.count - 1, next))
        selectedIndex = next
    }

    private func openDetail() {
        guard !items.isEmpty else { return }
        if selectedIndex == nil { selectedIndex = 0 }
        showingEdit = false
        showingDetail = true
    }

    // MARK: - フォルダ読み込み

    private func selectFolderAndLoad() {
        FileScanService.pickFolder { url in
            guard let url = url else { return }

            // 実際にフォルダ内の名前一覧を取得
            let names = FileScanService.loadFolderNames(from: url)

            // NameNormalizer は String -> String を返す想定
            let normalizedItems: [RenameItem] = names.map { name in
                let normalized = NameNormalizer.normalize(name)
                return RenameItem(
                    original: name,          // ← 旧（元のファイル名）
                    normalized: normalized,  // ← 新（正規化済み）
                    flagged: false
                )
            }

            DispatchQueue.main.async {
                self.items = normalizedItems
                self.selectedIndex = items.isEmpty ? nil : 0
            }
        }
    }
}
