// RenameDetailView.swift
import SwiftUI

struct RenameDetailView: View {

    let original: String
    let suggested: String

    @Binding var editedText: String

    let onResetToSuggested: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            // =========================
            // Header
            // =========================
            HStack {
                Text("Folder Organizer")
                    .font(.system(size: 22, weight: .bold))

                Spacer()

                Button("✕") {
                    onClose()
                }
            }

            Divider()

            // =========================
            // Old / Suggested
            // =========================
            VStack(alignment: .leading, spacing: 6) {

                labeledRow(
                    title: "旧",
                    text: original
                )

                labeledRow(
                    title: "提案",
                    text: suggested
                )
            }

            Divider()

            // =========================
            // Edit
            // =========================
            HStack {
                Text("編集")
                    .font(.headline)

                Spacer()

                Button("提案に戻す") {
                    onResetToSuggested()
                }
            }

            TextField("新しい名前を編集…", text: $editedText)
                .textFieldStyle(.roundedBorder)
                .font(.system(size: 15, design: .monospaced))

            labeledRow(
                title: "新",
                text: editedText.isEmpty ? suggested : editedText,
                emphasize: true
            )

            Spacer()
        }
        .padding(18)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Parts

    @ViewBuilder
    private func labeledRow(
        title: String,
        text: String,
        emphasize: Bool = false
    ) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("\(title):")
                .font(.system(size: 12))
                .opacity(0.7)

            Text(SpaceMarkerText.make(text))
                .font(
                    .system(
                        size: emphasize ? 14 : 12,
                        weight: emphasize ? .semibold : .regular,
                        design: .monospaced
                    )
                )
        }
    }
}
