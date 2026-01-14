// FolderOrganizer/Views/Welcome/WelcomeView.swift

import SwiftUI

struct WelcomeView: View {

    let onFolderSelected: (URL) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("FolderOrganizer v0.2")
                .font(.title2)

            Button("フォルダを選択") {
                openFolder()
            }

            Text("フォルダが選択されていません")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func openFolder() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let url = panel.url {
            onFolderSelected(url)   // ← ここが重要
        }
    }
}
