// Utilities/KeyboardExtension.swift
import SwiftUI
import AppKit

/// キー入力をグローバルに監視する ViewModifier
/// フォーカス（firstResponder）に依存しないので、
/// シート表示 → 閉じる → 一覧に戻っても矢印キー・Enter・Esc が確実に届く。
struct KeyDownModifier: ViewModifier {
    let handler: (NSEvent) -> Void

    func body(content: Content) -> some View {
        content.background(
            KeyMonitorView(handler: handler)
                .frame(width: 0, height: 0)   // 画面には見えない
        )
    }
}

/// NSViewRepresentable で NSEvent のローカルモニタを張る
private struct KeyMonitorView: NSViewRepresentable {
    let handler: (NSEvent) -> Void

    func makeNSView(context: Context) -> KeyMonitorNSView {
        let v = KeyMonitorNSView()
        v.handler = handler
        return v
    }

    func updateNSView(_ nsView: KeyMonitorNSView, context: Context) {
        nsView.handler = handler
    }
}

/// 実際に NSEvent.addLocalMonitorForEvents を使う NSView
private final class KeyMonitorNSView: NSView {

    var handler: ((NSEvent) -> Void)?
    private var monitor: Any?

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()

        // すでにモニタがあれば一度外す
        if let monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }

        guard window != nil else { return }

        // このウィンドウ内の keyDown を全部フックする
        monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self else { return event }

            // 将来 TextEditor で文字入力するときのために、
            // 「今の firstResponder が NSTextView なら何もしない」という保険も入れておく。
            if event.window?.firstResponder is NSTextView {
                return event
            }

            self.handler?(event)
            return event
        }
    }

    deinit {
        if let monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}

/// SwiftUI 側から使うための拡張
extension View {
    /// NSView の firstResponder に依存しない onKeyDown
    func onKeyDown(_ handler: @escaping (NSEvent) -> Void) -> some View {
        modifier(KeyDownModifier(handler: handler))
    }
}
