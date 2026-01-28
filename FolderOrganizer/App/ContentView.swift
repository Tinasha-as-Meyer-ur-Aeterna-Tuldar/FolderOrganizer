// FolderOrganizer/App/ContentView.swift
//
// v0.2 ContentView
// ・仮表示を廃止
// ・フォルダ選択〜一覧表示を最初の確認ポイントとする
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        FolderBrowseView()
            .frame(minWidth: 700, minHeight: 500)
    }
}
