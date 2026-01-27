// App/ContentView.swift
//
// v0.2 Apply / Export 再設計中の暫定 ContentView
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        VStack(spacing: 16) {
            Text("FolderOrganizer")
                .font(.system(size: 32, weight: .bold))

            Text("v0.2 – Apply / Export Redesign")
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}
