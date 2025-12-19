import SwiftUI

struct SpaceMarkerText {

    static func make(_ text: String) -> AttributedString {
        var result = AttributedString()

        for ch in text {
            if ch == " " {
                var a = AttributedString("␣")
                a.foregroundColor = AppTheme.colors.spaceMarkerHalf
                result.append(a)
            } else if ch == "　" {
                var a = AttributedString("▢")
                a.foregroundColor = AppTheme.colors.spaceMarkerFull
                result.append(a)
            } else {
                result.append(AttributedString(String(ch)))
            }
        }

        return result
    }
}
