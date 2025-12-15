//  Views/ContentView.swift
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {

    @State private var items: [RenameItem] = []
    @State private var selectedIndex: Int? = nil
    @State private var showingDetail = false

    var body: some View {
        ZStack {
            VStack(spacing: 24) {

                // タイトル
                Text("Folder Organizer")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppTheme.colors.titleText)
                    .padding(.top, 24)

                // フォルダ読み込みボタン
                Button {
                    selectFolderAndLoad()
                } label: {
                    Text("フォルダ名を読み込んで変換プレビュー")
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.colors.primaryButton)

                // 一覧
                RenamePreviewList(items: $items,
                                  selectedIndex: $selectedIndex)

                Spacer(minLength: 16)
            }
            .padding(.bottom, 24)
            .background(AppTheme.colors.background)

            // 詳細ポップアップ
            if showingDetail, let idx = selectedIndex, items.indices.contains(idx) {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()

                // ✅ C-2：Binding で渡す（編集が即時反映）
                RenameDetailView(
                    item: $items[idx],
                    index: idx,
                    total: items.count,
                    onPrev: movePrev,
                    onNext: moveNext,
                    onClose: { showingDetail = false }
                )
            }
        }

        // MARK: キーボード操作
        .onKeyDown { event in
            switch event.keyCode {
            case 126: moveSelection(delta: -1)        // ↑
            case 125: moveSelection(delta: 1)         // ↓
            case 36:  openDetail()                    // Return
            case 53:  showingDetail = false           // ESC
            default: break
            }
        }

        // MARK: 行をクリック → 通知で詳細を開く
        .onReceive(NotificationCenter.default.publisher(for: .openDetailFromList)) { _ in
            openDetail()
        }
    }

    // MARK: - キーボード移動
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
        showingDetail = true
    }

    private func movePrev() { moveSelection(delta: -1) }
    private func moveNext() { moveSelection(delta: 1) }

    // MARK: - フォルダ選択
    private func selectFolderAndLoad() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK {
            if let url = panel.url {
                loadFolderNames(from: url)
            }
        }
    }

    // MARK: - 指定フォルダの「直下のフォルダ名だけ」を取得
    private func loadFolderNames(from root: URL) {
        do {
            let contents = try FileManager.default.contentsOfDirectory(
                at: root,
                includingPropertiesForKeys: [.isDirectoryKey],
                options: [.skipsHiddenFiles]
            )

            // 直下のフォルダのみを抽出
            let onlyFolders = contents.filter { url in
                (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true
            }

            // RenameItem に変換
            self.items = onlyFolders.map { url in
                let name = url.lastPathComponent
                let result = NameNormalizer.normalize(name)
                print("====== NORMALIZE DEBUG ======")
                print("ORIGINAL   :", name)
                print("NORMALIZED :", result.normalizedName)
                print("DISPLAY    :", result.displayName)
                print("=============================")

                return RenameItem(
                    original: name,
                    normalized: result.displayName,
                    flagged: false
                )
            }

            selectedIndex = items.isEmpty ? nil : 0

        } catch {
            print("フォルダ読み込みエラー:", error)
        }
    }
}
