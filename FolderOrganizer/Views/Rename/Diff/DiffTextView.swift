//
//  Views/Rename/Preview/DiffTextView.swift
//
//  original / normalized を比較して表示
//  ・スペース可視化対応
//  ・Diff 表示は最低限（STEP 3-4 で拡張）
//

import SwiftUI

struct DiffTextView: View {

    let original: String
    let normalized: String
    let showSpaceMarkers: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            renderLine(text: original)
                .foregroundStyle(AppTheme.colors.secondaryText)

            renderLine(text: normalized)
                .foregroundStyle(.primary)
        }
        .font(.system(size: 13, design: .monospaced))
    }

    // MARK: - Render

    @ViewBuilder
    private func renderLine(text: String) -> some View {
        if showSpaceMarkers {
            renderWithSpaceMarkers(text)
        } else {
            Text(text)
        }
    }

    // MARK: - Space Marker Rendering

    private func renderWithSpaceMarkers(_ text: String) -> Text {
        var result = Text("")
        var spaceCount = 0

        for char in text {
            switch char {
            case " ":
                spaceCount += 1

            case "　":
                flushSpaces(&result, count: spaceCount)
                spaceCount = 0
                result = result + SpaceMarker.full()

            default:
                flushSpaces(&result, count: spaceCount)
                spaceCount = 0
                result = result + Text(String(char))
            }
        }

        flushSpaces(&result, count: spaceCount)
        return result
    }

    private func flushSpaces(_ result: inout Text, count: Int) {
        guard count > 0 else { return }

        if count == 1 {
            result = result + SpaceMarker.half()
        } else {
            result = result + SpaceMarker.multiple(count: count)
        }
    }
}
