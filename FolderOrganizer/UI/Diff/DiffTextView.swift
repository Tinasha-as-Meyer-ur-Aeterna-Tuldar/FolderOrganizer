import SwiftUI

struct DiffTextView: View {

    let segments: [DiffSegment]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments) { segment in
                textView(for: segment)
            }
        }
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private func textView(for segment: DiffSegment) -> some View {
        switch segment.type {

        case .unchanged:
            Text(segment.text)
                .foregroundColor(.primary)

        case .added:
            Text(segment.text)
                .foregroundColor(.green)
                .fontWeight(.semibold)

        case .removed:
            Text(segment.text)
                .foregroundColor(.red)
                .strikethrough()
        }
    }
}
