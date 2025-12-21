//
// App/ContentView.swift
//
import SwiftUI

struct ContentView: View {

    @State private var items: [RenameItem] = []
    @State private var selectedIndex: Int? = nil
    @State private var showSpaceMarkers: Bool = true

    var body: some View {
        VStack(spacing: 12) {

            Text("Folder Organizer")
                .font(.largeTitle)
                .bold()

            Button("フォルダ名を読み込んで変換プレビュー") {
                loadDummy()
            }

            Toggle("スペース可視化", isOn: $showSpaceMarkers)

            RenamePreviewList(
                items: $items,
                selectedIndex: $selectedIndex,
                showSpaceMarkers: showSpaceMarkers,
                onSelect: { index in
                    selectedIndex = index
                }
            )
        }
        .padding()
        .onAppear {
            if items.isEmpty {
                loadDummy()
            }
        }
    }

    private func loadDummy() {
        items = [
            RenameItem(
                id: UUID(),
                original: "sample  folder  name",
                normalized: "sample folder name",
                edited: "",
                flagged: false
            ),
            RenameItem(
                id: UUID(),
                original: "test　folder　name",
                normalized: "test folder name",
                edited: "",
                flagged: false
            )
        ]
    }
}
