// Views/RenameDetailView.swift
import SwiftUI

struct RenameDetailView: View {
    let original: String
    let suggested: String

    @Binding var editedText: String

    let onResetToSuggested: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Folder Organizer")
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Button("✕") { onClose() }
            }

            Group {
                Text("旧: \(original)")
                    .font(.system(size: 12))
                    .opacity(0.8)

                Text("提案: \(suggested)")
                    .font(.system(size: 12))
                    .opacity(0.8)
            }

            HStack {
                Text("編集:")
                    .font(.headline)

                Spacer()

                Button("提案に戻す") {
                    onResetToSuggested()
                }
            }

            TextField("新しい名前を編集…", text: $editedText)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 15))

            Text("新: \(editedText.isEmpty ? suggested : editedText)")
                .font(.system(size: 13, weight: .semibold))

            Spacer()
        }
        .padding(18)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
