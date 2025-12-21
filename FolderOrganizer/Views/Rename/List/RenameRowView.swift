//
// Views/RenameRowView.swift
//
import SwiftUI

struct RenameRowView: View {

    let item: RenameItem
    let showSpaceMarkers: Bool
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            VStack(alignment: .leading, spacing: 4) {

                SpaceMarkerTextView(
                    item.original,
                    showSpaceMarkers: showSpaceMarkers,
                    font: .system(size: 12)
                )
                .opacity(0.85)
                
                if showSpaceMarkers {
                    // ✅ showSpaceMarkers を必ず渡す
                    SpaceMarkerTextView(
                        item.displayNameForList,
                        showSpaceMarkers: showSpaceMarkers,
                        font: .system(size: 14, weight: .semibold, design: .monospaced)
                    )
                } else {
                    SpaceMarkerTextView(
                        item.displayNameForList,
                        showSpaceMarkers: showSpaceMarkers,
                        font: .system(size: 12)
                    )
                    .opacity(0.85)
                }
            }

            Spacer()

            Button("編集") { onEdit() }
        }
        .padding(.vertical, 8)
    }
}
