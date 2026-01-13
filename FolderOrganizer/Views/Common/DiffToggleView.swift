import SwiftUI

struct DiffToggleView: View {

    @AppStorage(DiffSettings.showDiffKey)
    private var showDiff: Bool = true

    var body: some View {
        Toggle(
            "差分表示を有効にする",
            isOn: $showDiff
        )
    }
}
