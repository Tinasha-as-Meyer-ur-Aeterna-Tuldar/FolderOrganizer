//
//  RenameListView.swift
//  FolderOrganizer
//

import SwiftUI

struct RenameListView: View {

    @ObservedObject var session: RenameSession

    var body: some View {
        List {
            // ✅ Binding ではなく値で回す
            ForEach(session.items) { item in
                Text(item.original)
            }
        }
        .listStyle(.plain)
    }
}
