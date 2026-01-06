//
//  Views/Rename/Diff/DiffTextView.swift
//  FolderOrganizer
//

import SwiftUI

struct DiffTextView: View {

    let tokens: [DiffToken]
    let font: Font

    var body: some View {
        tokens.reduce(Text("")) { partial, token in
            partial + Text(token.text)
                .font(font)
                .foregroundStyle(color(for: token.kind))
        }
    }

    private func color(for kind: DiffToken.Kind) -> Color {
        switch kind {
        case .same: return .primary
        case .added: return .green
        case .removed: return .red
        }
    }
}
